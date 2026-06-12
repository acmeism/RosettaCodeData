program CheckBCD;
// See https://wiki.freepascal.org/BcdUnit
{$IFDEF FPC}  {$MODE objFPC}{$ELSE} {$APPTYPE CONSOLE} {$ENDIF}
uses
  sysutils,fmtBCD {$IFDEF WINDOWS},Windows{$ENDIF}  ;

{type
  TBcd  = packed record
   Precision: Byte;
   SignSpecialPlaces: Byte;
   Fraction: packed array [0..31] of Byte;
 end;}
var
  Bcd0,Bcd1,BcdOut : tBCD;
Begin
  Bcd1 := IntegerToBcd(1);
//         0x19 + 1 = 0x20
  Bcd0 := IntegerToBcd(19);
  BcdAdd(Bcd0,Bcd1,BcdOut);
  writeln(BcdToStr(Bcd0),'+',BcdToStr(Bcd1),' =',BcdToStr(BcdOut));
//      0x30 - 1 = 0x29
  Bcd0 := IntegerToBcd(29);
  BcdAdd(Bcd0,Bcd1,BcdOut);
  writeln(BcdToStr(Bcd0),'+',BcdToStr(Bcd1),' =',BcdToStr(BcdOut));
//      0x99 + 1 = 0x100
  Bcd0 := IntegerToBcd(99);
  BcdAdd(Bcd0,Bcd1,BcdOut);
  writeln(BcdToStr(Bcd0),'+',BcdToStr(Bcd1),' =',BcdToStr(BcdOut));
  BcdMultiply(Bcd0,Bcd0,BcdOut);
  writeln(BcdToStr(Bcd0),'*',BcdToStr(Bcd0),' =',BcdToStr(BcdOut));
end.
