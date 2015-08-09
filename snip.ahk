#include snip_levels.ahk
#include <lib_CORE>
Core.init()

;__________________________________________________________________________________________________

;; Snip main class
class Snip extends SelectDialog {

    name           := "Snip"
    title          := "Snip"
    entries_map    := {}
    actions_folder := "__actions"
    level          := 0
    hide_specials  := 0

    win   := { listbox   : 0
             , edit      : 0
             , font      : "Segoe UI"
             , fontsize  : 11
             , controls: { "Edit1"       : "filter" }
             , hotkeys : { "+Enter"      : "enterSlot"
                         , "Enter"       : "enterSlot"
                         , "NumPadEnter" : "enterSlot"
                         , "Up"          : "arrowSlot"
                         , "Down"        : "arrowSlot"
                         , "+Up"         : "arrowSlot"
                         , "Tab"         : "tabSlot"
                         , "+Down"       : "arrowSlot" } }

    ;; Constructor
    __new(a_ini_path="") {

        ; Retrieve the base path and the special actionpath
        this.ini_file := a_ini_path

        ; Retrieve path from ini_file
        IniRead, l_path, % this.ini_file, general, path, % a_scriptdir "\snippets"
        this.path := l_path
        this.actions_folder := this.path "\" this.actions_folder

        ; Retrieve whether to hide special folders to users from ini_file
        IniRead, l_hide_specials, % this.ini_file, general, hide_specials
        this.hide_specials := l_hide_specials

        ; Setup levels
        this.levels := [ new SnipSelectLevel(this)
                       , new ActionSelectLevel(this) ]

        ; Show the window
        base.__new(this.getEntries())

    }
    
    ;; Get current level
    getCurrentLevel(){
        return this.levels[this.level + 1]
    }
    ;; Get entries from current level
    getEntries(){
        return this.getCurrentLevel().getEntries()
    }
    ;; Activate current level on enter
    go() {
        this.getCurrentLevel().go()
    }

    ;; Change level on tab
    tabSlot(){

        ; If you already are on the last level, just simulate enter and exit
        if (this.level == this.levels.maxindex()-1) {
            this.enterSlot()
            return
        }
        ; Otherwise, save selected entry from level 0
        this.selectedEntry := this.getCurrentLevel().getSelected()

        ; Change level
        this.level := 1

        ; Populate with new entries
        this.populate()
    }

    ;; Closewindow on escape
    escape() { 
        this.close()
    }

    ;; Populate the listbox with entries from the current level
    populate(){

        ; retrieve entries
        l_entries := this.getEntries()

        ; Setup the listbox
        this.listbox.set(l_entries)

        ; Autoselect first
        this.listbox.choose(1)

        ; Clear the edit and set focus
        this.entries := l_entries.join("|")
        this.controlSet(this.win.edit, "")
        ControlFocus,, % "ahk_id " this.win.edit

    }

    get_actions(a_extension) {

        l_actions := []
        l_extension := ""

        ; Read top actions for the extension from the ini_file
        while ( (l_actions.maxindex() <= 0) && (l_extension != "default") ){

            ; If you don't find the extension, try with "default"
            l_extension := (a_index == 1 ? a_extension : "default")

            IniRead, l_config, % this.ini_file, extensionsActions, % l_extension, %A_Space%

            ; If you find something, get it
            if (l_config != ""){
                l_actions := l_config.split(",")
            }
        }

        ; Add all other actions from the actions folder
        ls_mask := this.actions_folder "\*.ahk"

        l_files := ls_mask.getfiles()
        for _, l_action in l_files {
            l_action := l_action.basename().noextension()
            if (!instr(l_config, l_action)) {
                l_actions.insert(l_action)
            }
        }

        return l_actions
    }

    ;; Run selected action on specified file and close snip
    doAction(a_action, a_file){

        ; Build the command
        l_command := "%s %s\%s.ahk %s".fmt(A_AhkPath, this.actions_folder, a_action, a_file)

        ; Run the command
        Run, % l_command

    }

}

;________________________________________________________________________________________________

{

    ; General setup
    #Singleinstance force

    ; Retrieve hotkeys from the ini_file
    l_ini_file := a_scriptdir "\snip.ini"
    IniRead, l_hotkey_reload, % l_ini_file, general, reload, #r
    IniRead, l_hotkey_show,   % l_ini_file, general, show,   !Esc

    ; Change tray icon
    IniRead, l_icon, % l_ini_file, general, icon, snip.ico
    Menu, Tray, Icon, % l_icon

    ; Activate the hotkeys
    Hotkey, % l_hotkey_reload, Snip_Reload
    Hotkey, % l_hotkey_show,   Snip_Show

    return

}

; Reload script hotkey
Snip_Reload:
    Reload
return

; Show snip window hotkey
Snip_Show:
    ; Read path from ini_file
    Snip := new Snip(a_scriptdir "\snip.ini")
    Snip.show()

    Log := new Log("snip.log")

return



