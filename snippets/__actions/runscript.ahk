#include <lib_CORE>
Core.init()

; Retrieve parameter
l_parm = %1%

; Build the command
l_command := A_AhkPath " " l_parm

; Run the script
Run, % l_command

ExitApp