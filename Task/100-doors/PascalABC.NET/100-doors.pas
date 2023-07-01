// 100 doors. Nigel Galloway: January 1th., 2023
type doorState=(Open,Closed);
function flip(n:doorState):doorState:=if n=Open then Closed else Open;
var Doors:Array of doorState:=ArrFill(100,Closed);
begin
  for var n:=1 to 100 do for var g:=n-1 to 99 step n do Doors[g]:=flip(Doors[g]);
  for var n:=0 to 99 do if Doors[n]=Open then write(n+1,' '); writeLn
end.
