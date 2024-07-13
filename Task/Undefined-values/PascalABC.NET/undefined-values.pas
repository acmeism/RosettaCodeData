function Gen: integer? := Random(2)=0 ? 777 : nil;

begin
  var i: integer?;
  i := Gen();
  if i.HasValue then
    Print(i.Value)
  else Print('No value')
end.
