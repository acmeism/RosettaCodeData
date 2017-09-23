def F(x):
  def M(x): if x == 1 then F(x) else 2 end;
  if x == 0 then M(x) else 1 end;

def M(x): if x == 1 then F(x) else 2 end;
