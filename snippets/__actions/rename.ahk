#include <lib_CORE>
Core.init()

; Retrieve parameter
l_parm = %1%

l_file  := ""
l_title := "Rename Snip"
l_desc  := "Rename Snip, enter new filename:"
l_w     := 450
l_h     := 130
l_font  := "Segoe UI"

Loop
{
    ; Ask user a valid filename 
    InputBox, l_file, %l_title%, %l_desc%,, %l_w%, %l_h%,,,,, %l_parm%

    ; If you ain't got one, exit
    if (errorlevel) {
        break
    }

    ; Error if already exists
    if fileexist(l_file) {
        Msgbox, % "(%s) already exists.".fmt(l_file)
        continue
    }

    ; Rename file
    FileMove, %l_parm%, %l_file%
    
    ; If everything was done correctly, exit
    Break

}

ExitApp

