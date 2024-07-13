begin
  var pi: ^integer;
  New(pi);
  pi^ := 3;
  Writeln(pi,' ',pi^);
  pi^ := 5;
  Writeln(pi,' ',pi^);
  var pi1: ^integer := pi;
  pi1^ := 666;
  Writeln(pi1,' ',pi1^);
  Writeln(pi,' ',pi^);
end.
