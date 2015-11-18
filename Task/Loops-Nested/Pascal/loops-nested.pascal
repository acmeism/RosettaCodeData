program LoopNested;
uses SysUtils;
const Ni=10; Nj=20;
var
  tab: array[1..Ni,1..Nj] of Integer;
  i, j: Integer;
label loopend;
begin
  for i := 1 to Ni do
    for j := 1 to Nj do
      tab[i,j]:=random(20)+1;
  for i := 1 to Ni do
  begin
    for j := 1 to Nj do
    begin
      WriteLn(tab[i,j]);
      if tab[i,j]=20 then goto loopend
    end
  end;
loopend:
end.
