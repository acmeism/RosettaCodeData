begin

comment - 100 doors problem in ALGOL-60;

boolean array doors[1:100];
integer i, j;
boolean open, closed;

open := true;
closed := not true;

outstring(1,"100 Doors Problem\n");

comment - all doors are initially closed;
for i := 1 step 1 until 100 do
  doors[i] := closed;

comment
  cycle through at increasing intervals
  and flip each door encountered;
for i := 1 step 1 until 100 do
  for j := i step i until 100 do
    doors[j] := not doors[j];

comment - show which doors are open;
outstring(1,"The open doors are:");
for i := 1 step 1 until 100 do
  if doors[i] then
     outinteger(1,i);

end
