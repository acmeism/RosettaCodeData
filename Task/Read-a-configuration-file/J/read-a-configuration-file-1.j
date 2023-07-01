require'regex'
set=:4 :'(x)=:y'

cfgString=:4 :0
  y set ''
  (1;&,~'(?i:',y,')\s*(.*)') y&set rxapply x
)

cfgBoolean=:4 :0
  y set 0
  (1;&,~'(?i:',y,')\s*(.*)') y&set rxapply x
  if.-.0-:y do.y set 1 end.
)

taskCfg=:3 :0
  cfg=: ('[#;].*';'') rxrplc 1!:1<y
  cfg cfgString 'fullname'
  cfg cfgString 'favouritefruit'
  cfg cfgBoolean 'needspeeling'
  cfg cfgBoolean 'seedsremoved'
  i.0 0
)
