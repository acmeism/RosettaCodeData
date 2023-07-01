define(`forever',
   `ifelse($#,0,``$0'',
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',eval($2+$3),$3,`$4')')')dnl
forever(`y',0,1, `eval(y,8)
')
