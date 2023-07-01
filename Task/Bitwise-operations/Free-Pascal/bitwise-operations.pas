program Bitwise;
{$mode objfpc}
var
  // Pascal uses a native int type as a default literal type
  // Make sure the operants work on an exact type.
  x:shortint = 2;
  y:ShortInt = 3;
begin
  Writeln('2 and 3 = ', x and y);
  Writeln('2 or 3 = ', x or y);
  Writeln('2 xor 3 = ', x xor y);
  Writeln('not 2 = ', not x);
  Writeln('2 shl 3 = ', x >> y);
  Writeln('2 shr 3 = ', x << y);
  writeln('2 rol 3 = ', rolbyte(x,y));
  writeln('2 ror 3 = ', rorbyte(x,y));
  writeln('2 sar 3 = ', sarshortint(x,y));
  Readln;
end.
