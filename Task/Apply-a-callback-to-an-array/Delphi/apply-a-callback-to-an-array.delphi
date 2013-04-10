// Declare the callback function
procedure callback(const AInt:Integer);
begin
  WriteLn(AInt);
end;

const
  // Declare a static array
  myArray:Array[0..4] of Integer=(1,4,6,8,7);
var
  // Declare interator variable
  i:Integer;
begin
  // Iterate the array and apply callback
  for i:=0 to length(myArray)-1 do
    callback(myArray[i]);
end.
