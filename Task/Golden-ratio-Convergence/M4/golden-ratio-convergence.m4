divert(-1)

define(`iterate',`define(`iterations',0)`'_$0(`$1')')
define(`_iterate',
  `define(`iterations',eval(iterations + 1))`'dnl
pushdef(`phi1',eval(10000 + ((10000 * 10000) / ($1))))`'dnl
pushdef(`diff',ifelse(eval((phi1 - ($1)) < 0),1,dnl
eval(($1) - phi1),eval(phi1 - ($1))))`'dnl
ifelse(eval(diff < 1),1,phi1,`_iterate(phi1)')`'dnl
popdef(`phi1',`diff')')

divert`'dnl
eval(iterate(10000) / 10000)`.'eval(iterate(10000) % 10000)
iterations `iterations'
