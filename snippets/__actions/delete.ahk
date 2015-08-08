#include <lib_CORE>
Core.init()

; Retrieve parameter
l_file = %1%

; Ask confirmation
MsgBox, 0x131, Confirm, % "Delete (%s) ?".fmt(l_file)

; Delete file if confirmed
IfMsgBox Ok
    FileDelete, %l_file%


ExitApp
