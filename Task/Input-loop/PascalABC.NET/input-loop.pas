begin
  var f := OpenRead('a.txt');
  while not f.Eof do
    Println(f.ReadString);
  f.Close;
end.
