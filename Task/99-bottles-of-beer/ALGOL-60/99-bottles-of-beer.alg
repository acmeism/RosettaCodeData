begin
  integer n;

  for n:= 99 step -1 until 2 do
     begin
      outinteger(1,n);	
	  outstring(1,"bottles of beer on the wall,");
      outinteger(1,n);
      outstring(1,"bottles of beer.\nTake one down and pass it around,");
      outstring(1,"of beer on the wall...\n\n")
     end;

  outstring(1," 1 bottle of beer on the wall, 1 bottle of beer.\n");
  outstring(1,"Take one down and pass it around, no more bottles of beer on the wall...\n\n");

  outstring(1,"No more bottles of beer on the wall, no more bottles of beer.\n");
  outstring(1,"Go to the store and buy some more, 99 bottles of beer on the wall.")
end
