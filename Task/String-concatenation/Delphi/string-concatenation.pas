program Concat;

{$APPTYPE CONSOLE}

var
  s1, s2: string;
begin
  s1 := 'Hello';
  s2 := s1 + ' literal';
  WriteLn(s1);
  WriteLn(s2);
end.
