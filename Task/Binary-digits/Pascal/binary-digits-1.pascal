program IntToBinTest;
{$MODE objFPC}
uses
  strutils;//IntToBin
function WholeIntToBin(n: NativeUInt):string;
var
  digits: NativeInt;
begin
// BSR?Word -> index of highest set bit but 0 -> 255 ==-1 )
  IF n <> 0 then
  Begin
{$ifdef CPU64}
    digits:= BSRQWord(NativeInt(n))+1;
{$ELSE}
    digits:= BSRDWord(NativeInt(n))+1;
{$ENDIF}
   WholeIntToBin := IntToBin(NativeInt(n),digits);
  end
  else
    WholeIntToBin:='0';
end;
procedure IntBinTest(n: NativeUint);
Begin
  writeln(n:12,' ',WholeIntToBin(n));
end;
BEGIN
  IntBinTest(5);IntBinTest(50);IntBinTest(5000);
  IntBinTest(0);IntBinTest(NativeUint(-1));
end.
