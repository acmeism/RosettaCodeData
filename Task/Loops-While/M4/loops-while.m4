divert(-1)

define(`loop',
  `ifelse(eval(0 < ($1)),1,`$1`
'loop(eval(($1) / 2))')')

divert`'dnl
loop(1024)dnl
