;__________________________________________________________________________________________________

;; Base class for Snip levels
class SnipLevel {
    number := 0
    parent := ""

    __new(a_parent) {
        this.parent := a_parent
    }

    getEntries() {
    }

    getSelected(){
    }

    go() {
    }

}

;__________________________________________________________________________________________________

;; Level 0 class
class SnipSelectLevel extends SnipLevel {

    ;; getSelected
    getSelected(){
        l_file := this.parent.controlGet(this.parent.listbox.hwnd)
        l_file := this.parent.entries_map[l_file]
        return l_file
    }
    
    ;; Get files from Snip directory
    getEntries(){

        ; Cleanup
        this.parent.selectedEntry := ""

        ; Retrieve files
        l_mask := this.parent.path "\*.*"
        l_entries := l_mask.getfiles(0, 1)

        ; Hide specials if required
        if (this.parent.hide_specials){
            l_filtered := {}
            for k, v in l_entries {
                ls := v.replace(this.parent.path "\", "")
                if (ls.left(2) != "__"){
                    l_filtered.insert(v)
                }
            }
            l_entries := l_filtered
        }

        ; Cleanup names, making them relative to the basepath
        this.parent.entries_map := {}
        for k, v in l_entries {
            k := v.replace(this.parent.path "\", "")
            this.parent.entries_map.insert(k, v)
        }
        l_entries := this.parent.entries_map.keys()
        
        return l_entries

    }

    ;; Run default action on selected file
    go(){

        ; Get selected filename and extension
        l_file := this.getSelected()
        if (l_file == ""){
            return
        }
        l_extension := l_file.extension().toLower()

        this.parent.doAction(this.parent.get_actions(l_extension)[1], l_file)
    }

}

;__________________________________________________________________________________________________

;; Level 1 class
class ActionSelectLevel extends SnipLevel {

    ;; Get actions
    getEntries() {
        l_extension := this.parent.selectedEntry.extension().toLower()
        return this.parent.get_actions(l_extension)
    }

    ;; Run selected action on the selected file saved in level 0
    go() {
        this.parent.doAction(this.parent.returnValue, this.parent.selectedEntry)
    }

}

;__________________________________________________________________________________________________


