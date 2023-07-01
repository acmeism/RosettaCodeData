divert(-1)

#
# m4 is a macro language, so this is just a matter of defining a
# macro, using the built-in branching macro "ifelse".
#
# ifelse2(x1,x2,y1,y2,exprxy,exprx,expry,expr)
#
# Checks if x1 and x2 are equal strings and if y1 and y2 are equal
# strings.
#
define(`ifelse2',
  `ifelse(`$1',`$2',`ifelse(`$3',`$4',`$5',`$6')',
          `ifelse(`$3',`$4',`$7',`$8')')')

divert`'dnl
dnl
ifelse2(1,1,2,2,`exprxy',`exprx',`expry',`expr')
ifelse2(1,1,2,-2,`exprxy',`exprx',`expry',`expr')
ifelse2(1,-1,2,2,`exprxy',`exprx',`expry',`expr')
ifelse2(1,-1,2,-2,`exprxy',`exprx',`expry',`expr')
