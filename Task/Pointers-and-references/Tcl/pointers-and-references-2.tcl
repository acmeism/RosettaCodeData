set arr(var) 3
set pointer var
set arr($pointer);         # returns 3
set arr($pointer) 42;      # arr(var) now has value 42

set var 3
set pointer var
upvar 0 $pointer varAlias; # varAlias is now the same variable as var
set varAlias 42;           # var now has value 42
