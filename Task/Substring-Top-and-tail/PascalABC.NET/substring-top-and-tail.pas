{$zerobasedstrings}
begin
  var s := '0123456789';
  Writeln(s[1:]);
  Writeln(s[:^1]);
  Writeln(s[1:^1]);
end.
