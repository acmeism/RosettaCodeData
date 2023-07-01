define(`foreach', `pushdef(`$1')_foreach($@)popdef(`$1')')dnl
define(`_arg1', `$1')dnl
define(`_foreach', `ifelse(`$2', `()', `',
   `define(`$1', _arg1$2)$3`'$0(`$1', (shift$2), `$3')')')dnl
dnl
define(`apply',`foreach(`x',$1,`$2(x)')')dnl
dnl
define(`z',`eval(`$1*2') ')dnl
apply(`(1,2,3)',`z')
