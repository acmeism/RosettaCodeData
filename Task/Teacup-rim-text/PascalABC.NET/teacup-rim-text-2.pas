foreach var n in fN('words_alpha.txt').GroupBy(n->n.length) do begin
  var g:= fI(n.ToHashSet,n.First.Length);
  if g.Count>0 then println(g);
end;
