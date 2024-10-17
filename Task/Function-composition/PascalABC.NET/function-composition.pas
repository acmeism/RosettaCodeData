function Compose<T,T1,T2>(f: T1 -> T2; g: T -> T1): T -> T2 := x -> f(g(x));

begin
  Compose(Sin,ArcSin)(1.0).Print
end.
