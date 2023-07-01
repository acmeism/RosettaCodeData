define(`set2d',`define(`$1[$2][$3]',`$4')')
define(`get2d',`defn($1[$2][$3])')
define(`tryboth',
   `pushdef(`x',lcs(`$1',substr(`$2',1),`$1 $2'))`'pushdef(`y',
         lcs(substr(`$1',1),`$2',`$1 $2'))`'ifelse(eval(len(x)>len(y)),1,
         `x',`y')`'popdef(`x')`'popdef(`y')')
define(`checkfirst',
   `ifelse(substr(`$1',0,1),substr(`$2',0,1),
      `substr(`$1',0,1)`'lcs(substr(`$1',1),substr(`$2',1))',
      `tryboth(`$1',`$2')')')
define(`lcs',
   `ifelse(get2d(`c',`$1',`$2'),`',
        `pushdef(`a',ifelse(
           `$1',`',`',
           `$2',`',`',
           `checkfirst(`$1',`$2')'))`'a`'set2d(`c',`$1',`$2',a)`'popdef(`a')',
        `get2d(`c',`$1',`$2')')')

lcs(`1234',`1224533324')

lcs(`thisisatest',`testing123testing')
