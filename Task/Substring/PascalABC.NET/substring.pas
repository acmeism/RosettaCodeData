{$zerobasedstrings}
const
  n = 3;
  m = 2;

begin
  var s := '0123456789';
  Writeln(s.Substring(n, m));
  Writeln(s[n:]);
  Writeln(s[:^1]);
  Writeln(s.Substring(s.IndexOf('3'), m));
  Writeln(s.Substring(s.IndexOf('456'), m));
end.
