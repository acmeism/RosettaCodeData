program CopyString;

{$APPTYPE CONSOLE}

var
  s1: string;
  s2: string;
begin
  s1 := 'Goodbye';
  s2 := s1; // S2 points at the same string as S1
  s2 := s2 + ', World!'; // A new string is created for S2

  Writeln(s1);
  Writeln(s2);
end.
