define(`def2', `define(`$1',`$2')define(`$3',`$4')')dnl
define(`swap', `def2(`$1',defn(`$2'),`$2',defn(`$1'))')dnl
dnl
define(`a',`x')dnl
define(`b',`y')dnl
a b
swap(`a',`b')
a b
