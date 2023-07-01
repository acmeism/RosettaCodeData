edge_to_node=: 3 :0
 assert. 2 = #/.~ , y [ 'expect each node to appear twice'
 oel=. 1 2 {. y
 Y=. }. y
 while. # Y do.
  i =. <. -: 1 i.~ , Y (e."1) {: oel
  assert. 0 < # i [ 'isolated edge detected'
  oel =. oel , i { Y
  Y =. i ({. , (}.~ >:)~) Y
 end.
 ~. , oel
)
