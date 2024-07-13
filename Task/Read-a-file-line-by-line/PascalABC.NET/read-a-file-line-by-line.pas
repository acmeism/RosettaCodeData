begin
  var f := OpenRead('_a.pas');
  while not f.Eof do
    Println(f.ReadString);
  f.Close
end.
