program Bitwise;

{$APPTYPE CONSOLE}

begin
  Writeln('2 and 3 = ', 2 and 3);
  Writeln('2 or 3 = ', 2 or 3);
  Writeln('2 xor 3 = ', 2 xor 3);
  Writeln('not 2 = ', not 2);
  Writeln('2 shl 3 = ', 2 shl 3);
  Writeln('2 shr 3 = ', 2 shr 3);
// there are no built-in rotation operators in Delphi
  Readln;
end.
