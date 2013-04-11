floor[x_,y_]:=Flatten[Position[y,x]][[1]]
Select[Permutations[{"Baker","Cooper","Fletcher","Miller","Smith"}],
  ( floor["Baker",#] < 5 )
&&( Abs[floor["Fletcher",#] - floor["Cooper",#]] > 1 )
&&( Abs[floor["Fletcher",#] - floor["Smith",#]] > 1 )
&&( 1 < floor["Cooper",#] < floor["Miller",#] )
&&( 1 < floor["Fletcher",#] < 5 )
&]  [[1]] //Reverse //Column

->
Miller
Fletcher
Baker
Cooper
Smith
