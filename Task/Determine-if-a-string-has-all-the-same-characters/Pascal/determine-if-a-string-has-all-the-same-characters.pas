program SameNessOfChar;
{$IFDEF FPC}
   {$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$CODEALIGN proc=16}{$ALIGN 16}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils;//Format
const
  TestData : array[0..6] of String =
     ('','   ','2','333','.55','tttTTT','4444 444k');
function PosOfDifferentChar(const s: String):NativeInt;
var
  i: Nativeint;
  ch:char;
Begin
  result := length(s);
  IF result < 2 then
    EXIT;
  ch := s[1];
  i := 2;
  while (i< result) AND (S[i] =ch) do
    inc(i);
  result := i;
end;

procedure OutIsAllSame(const s: String);
var
  l,len: NativeInt;
Begin
  l := PosOfDifferentChar(s);
  len := Length(s);
  write('"',s,'" of length ',len);
  IF l = len then
    writeln(' contains all the same character')
  else
    writeln(Format(' is different at position %d "%s" (0x%X)',[l,s[l],Ord(s[l])]));
end;

var
  i : NativeInt;
begin
  For i := Low(TestData) to HIgh(TestData) do
    OutIsAllSame(TestData[i]);
end.
