function k(n : Integer) := 1.to(n div 2).where(d->n mod d=0).sum;
begin
1.to(20000).Where(n->n=k(k(n)))
.Select(n->
  begin var m:=k(n);
Result:=(min(n,m),max(n,m));
  end).where(v->v[0]<v[1]).Distinct
.Select(v->$'{v[0]}-{v[1]}').Printlines;
end.
