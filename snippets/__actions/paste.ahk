#include <lib_CORE>
Core.init()

; Retrieve parameter
l_parm = %1%

; Read the file into variable
FileRead, ls, % l_parm 

; Paste
Clip.ensurePaste(ls)

ExitApp
