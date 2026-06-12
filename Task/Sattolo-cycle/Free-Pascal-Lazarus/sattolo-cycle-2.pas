program sattologeneric;
{$if fpc_fullversion < 30301}{$fatal needs fpc331 or higher}{$endif}
{$mode delphi}{$modeswitch implicitfunctionspecialization}
{
  open array parameters are not inlined,
  but TArray<T> is inlined
}

procedure Sattolo<T>(var arr:TArray<T>);inline;
var
 i,j:integer;
 temp:T;
begin
  for i := High(arr) downto 1 do
  begin
    j := Random(i);
    temp  := arr[i];// can't
    arr[i]:= arr[j];// use
    arr[j]:= temp;  // xor
  end;
end;


var
  a:Array of integer = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19];
  c:integer;
begin
  randseed := 0;
  { implicit specialization }
  Sattolo(a);
  for c in a do write(c:3);
  writeln;
end.
