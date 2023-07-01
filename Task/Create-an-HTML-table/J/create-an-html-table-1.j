ele=:4 :0
  nm=. x-.LF
  lf=. x-.nm
  ;('<',nm,'>') ,L:0 y ,L:0 '</',nm,'>',lf
)

hTbl=:4 :0
  rows=. 'td' <@ele"1 ":&.>y
  'table' ele ('tr',LF) <@ele ('th' ele x); rows
)
