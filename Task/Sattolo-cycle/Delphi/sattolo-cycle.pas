program sattolo;
{$APPTYPE CONSOLE}
{$R *.res}

procedure SattoloCycle(var arr: array of integer);
var
 i,j:integer;
begin
  for i := High(arr) downto 1 do
  begin
    j := Random(i);
    arr[i] := arr[i] xor arr[j];// swap
    arr[j] := arr[j] xor arr[i];// without
    arr[i] := arr[i] xor arr[j];// temp
  end;
end;


var
  a:Array of integer = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19];
  c:integer;
begin
  Randomize;
  SattoloCycle(a);
  for c in a do write(c:3);
  readln;
end.
