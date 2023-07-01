program Pot5Test;
{$IFDEF FPC} {$MODE DELPHI}{$ELSE]{$APPTYPE CONSOLE}{$ENDIF}
type
  tTest = double;//UInt64;{ On linux 32Bit double is faster than  Uint64 }
var
  Pot5 : array[0..255] of tTest;
  res,tmpSum : tTest;
  x0,x1,x2,x3, y : NativeUint;//= Uint32 or 64 depending on OS xx-Bit
  i : byte;
BEGIN
  For i := 1 to 255 do
    Pot5[i] := (i*i*i*i)*Uint64(i);

  For x0 := 1 to 250-3 do
    For x1 := x0+1 to 250-2 do
      For x2 := x1+1 to 250-1 do
      Begin
        //set y here only, because pot5 is strong monoton growing,
        //therefor the sum is strong monoton growing too.
        y := x2+2;// aka x3+1
        tmpSum := Pot5[x0]+Pot5[x1]+Pot5[x2];
        For x3 := x2+1 to 250 do
        Begin
          res := tmpSum+Pot5[x3];
          while (y< 250) AND (res > Pot5[y]) do
            inc(y);
          IF y > 250 then BREAK;
          if res = Pot5[y] then
            writeln(x0,'^5+',x1,'^5+',x2,'^5+',x3,'^5 = ',y,'^5');
        end;
      end;
END.
