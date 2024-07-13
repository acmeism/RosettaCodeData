begin
  var q := new Queue<integer>;
  for var i:=1 to 5 do
    q.Enqueue(i);
  while q.Count > 0 do
    Print(q.Dequeue);
end.
