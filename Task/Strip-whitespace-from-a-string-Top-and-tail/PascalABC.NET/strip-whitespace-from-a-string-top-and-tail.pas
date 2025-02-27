begin
  var s := #9'  abc  '#9;         // #9 = TAB
  Writeln('|', s.TrimStart,'|');
  Writeln('|', s.TrimEnd,'|');
  Writeln('|', s.Trim,'|');
end.
