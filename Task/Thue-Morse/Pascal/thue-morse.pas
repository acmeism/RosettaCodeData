Program ThueMorse;

function fThueMorse(maxLen: NativeInt):AnsiString;
//double by appending the flipped original 0 -> 1;1 -> 0
//Flipping between two values:x oszillating A,B,A,B -> x_next = A+B-x
//Beware A+B < High(Char), the compiler will complain ...
const
  cVal0 = '^';cVal1 = 'v';//  cVal0 = '0';cVal1 = '1';

var
  pOrg,
  pRpl : pansiChar;
  i,k,ml : NativeUInt;//MaxLen: NativeInt
Begin
  iF maxlen < 1 then
  Begin
    result := '';
    EXIT;
  end;
  //setlength only one time
  setlength(result,Maxlen);

  pOrg := @result[1];
  pOrg[0] := cVal0;
  IF maxlen = 1 then
    EXIT;

  pRpl := pOrg;
  inc(pRpl);
  k := 1;
  ml:= Maxlen;
  repeat
    i := 0;
    repeat
      pRpl[0] := ansichar(Ord(cVal0)+Ord(cVal1)-Ord(pOrg[i]));
      inc(pRpl);
      inc(i);
    until i>=k;
    inc(k,k);
  until k+k> ml;
  // the rest
  i := 0;
  k := ml-k;
  IF k > 0 then
    repeat
      pRpl[0] := ansichar(Ord(cVal0)+Ord(cVal1)-Ord(pOrg[i]));
      inc(pRpl);
      inc(i)
    until i>=k;
end;

var
 i : integer;
Begin
  For i := 0 to 8 do
    writeln(i:3,'  ',fThueMorse(i));
  fThueMorse(1 shl 30);
  {$IFNDEF LINUX}readln;{$ENDIF}
end.
