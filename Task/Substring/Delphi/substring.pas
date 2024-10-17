program ShowSubstring;

{$APPTYPE CONSOLE}

uses SysUtils;

const
  s = '0123456789';
  n = 3;
  m = 4;
  c = '2';
  sub = '456';
begin
  Writeln(Copy(s, n, m));             // starting from n characters in and of m length;
  Writeln(Copy(s, n, Length(s)));     // starting from n characters in, up to the end of the string;
  Writeln(Copy(s, 1, Length(s) - 1)); // whole string minus last character;
  Writeln(Copy(s, Pos(c, s), m));     // starting from a known character within the string and of m length;
  Writeln(Copy(s, Pos(sub, s), m));   // starting from a known substring within the string and of m length.
end.
