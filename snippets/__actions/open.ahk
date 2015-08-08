#include <lib_CORE>
Core.init()

; Retrieve parameter
l_file = %1%

; Open the file
Run, open %l_file%

ExitApp