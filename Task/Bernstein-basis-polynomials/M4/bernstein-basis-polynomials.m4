divert(-1)

#
# POSIX m4 has only "signed integer arithmetic with at least 32-bit
# precision", so I use integers and scaling.
#
# Be aware that overflows might be silently ignored by m4, resulting
# in nonsense being printed. I demonstrate this below (where the value
# of the polynomial exceeds four times the cube of 7.50).
#
# (Were I trying to implement this task more reliably, it would be by
# first implementing decimal arithmetic in m4, with a large or
# arbitrary number of digits. Which is something I have not, to date,
# ever done.)
#

define(`printnum',`eval(($1)/10000).eval(($1)%10000)')

define(`printpoly2',`_$0($1)')
define(`_printpoly2',
  `(printnum($1), printnum($2), printnum($3))')

define(`printpoly3',`_$0($1)')
define(`_printpoly3',
  `(printnum($1), printnum($2), printnum($3), printnum($4))')

# Subprogram (1).
define(`tobern2',`_$0($1)')
define(`_tobern2',
  `$1,eval(($1) + (($2) * 5)/10),eval(($1) + ($2) + ($3))')

# Subprogram (2).
define(`evalbern2',`_$0($1,$2)')
define(`_evalbern2',
  `pushdef(`t',eval(($4)))`'pushdef(`s',eval(100 - t))dnl
pushdef(`b01',eval((s * ($1))/100 + (t * ($2))/100))dnl
pushdef(`b12',eval((s * ($2))/100 + (t * ($3))/100))dnl
eval((s * b01)/100 + (t * b12)/100)dnl
popdef(`s',`t',`b01',`b12')')

# Subprogram (3).
define(`tobern3',`_$0($1)')
define(`_tobern3',
  `$1,eval(($1) + (($2) * 3333)/10000),dnl
eval(($1) + (($2) * 6667)/10000 + (($3) * 3333)/10000),dnl
eval(($1) + ($2) + ($3) + ($4))')

# Subprogram (4).
define(`evalbern3',`_$0($1,$2)')
define(`_evalbern3',
  `pushdef(`t',eval(($5)))`'pushdef(`s',eval(100 - t))dnl
pushdef(`b01',eval((s * ($1))/100 + (t * ($2))/100))dnl
pushdef(`b12',eval((s * ($2))/100 + (t * ($3))/100))dnl
pushdef(`b23',eval((s * ($3))/100 + (t * ($4))/100))dnl
pushdef(`b012',eval((s * b01)/100 + (t * b12)/100))dnl
popdef(`b01')dnl
pushdef(`b123',eval((s * b12)/100 + (t * b23)/100))dnl
popdef(`b12',`b23')dnl
eval((s * b012)/100 + (t * b123)/100)dnl
popdef(`s',`t',`b012',`b123')')

# Subprogram (5).
define(`bern2to3',`_$0($1)')
define(`_bern2to3',
  `$1,eval((($1) * 3333)/10000 + (($2) * 6667)/10000),dnl
eval((($2) * 6667)/10000 + (($3) * 3333)/10000),$3')

define(`pmono2',``10000,00000,00000'')
define(`qmono2',``10000,20000,30000'')

define(`pbern2',`tobern2(pmono2)')
define(`qbern2',`tobern2(qmono2)')

define(`pmono3',``10000,00000,00000,00000'')
define(`qmono3',``10000,20000,30000,00000'')
define(`rmono3',``10000,20000,30000,40000'')
define(`pbern3',`tobern3(pmono3)')
define(`qbern3',`tobern3(qmono3)')
define(`rbern3',`tobern3(rmono3)')

define(`pbern3a',`bern2to3(`pbern2')')
define(`qbern3a',`bern2to3(`qbern2')')

divert`'dnl
Subprogram (1) examples:
  mono printpoly2(pmono2) --> bern printpoly2(`pbern2')
  mono printpoly2(qmono2) --> bern printpoly2(`qbern2')
Subprogram (2) examples:
  p(0.25) = printnum(evalbern2(`pbern2',25))
  p(7.50) = printnum(evalbern2(`pbern2',750))
  q(0.25) = printnum(evalbern2(`qbern2',25))
  q(7.50) = printnum(evalbern2(`qbern2',750))
Subprogram (3) examples:
  mono printpoly3(pmono3) --> bern printpoly3(`pbern3')
  mono printpoly3(qmono3) --> bern printpoly3(`qbern3')
  mono printpoly3(rmono3) --> bern printpoly3(`rbern3')
Subprogram (4) examples:
  p(0.25) = printnum(evalbern3(`pbern3',25))
  p(7.50) = printnum(evalbern3(`pbern3',750))
  q(0.25) = printnum(evalbern3(`qbern3',25)) <-- rounding error
  q(7.50) = printnum(evalbern3(`qbern3',750)) <-- rounding error
  r(0.25) = printnum(evalbern3(`rbern3',25)) <-- rounding error
  r(7.50) = printnum(evalbern3(`rbern3',750)) <-- overflow
Subprogram (5) examples:
  printpoly2(`pbern2') --> printpoly3(`pbern3a')
  printpoly2(`qbern2') --> printpoly3(`qbern3a')
