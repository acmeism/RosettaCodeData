begin
  var f := OpenRead('a.txt',Encoding.UTF8);
  while not f.Eof do
    Print(f.ReadChar);
  f.Close
end.
