parseaddr=:3 :0
  if. '.' e. y do.
    if. +./'::' E. y do.
      parsehybrid y
    else.
      parseipv4 y
    end.
  else.
    parseipv6 y
  end.
)

parseipv4=:3 :0
  'addr port'=. 2{.<;._2 y,'::'
  4,((4#256)#._&".;._1'.',addr),_".port
)

parseipv6=:3 :0
  'addr port'=. 2{.<;._2 (y-.'['),']]'
  split=. I. '::' E. addr
  a1=. 8{. dfh;._2 (split {. addr),8#':'
  a2=._8{. dfh;._1 (8#':'),split }. addr
  6,(65536x#.a1+a2),_".port-.':'
)

parsehybrid=:3 :0
  'kludge port'=. 2{.<;._2 (tolower y-.'['),']]'
  addr=. _1 {:: <;._2 kludge,':'
  assert. (kludge-:'::ffff:',addr) +. kludge-: '::',addr
  6,(16bffff00000000+1{parseipv4 addr),_".port-.':'
)

fmt=:3 :0
  port=. ''
  ((#y){.'v';'addr';'port')=. y
  'ipv',(":v),' ',(hfd addr),(#port)#' ',":port
)
