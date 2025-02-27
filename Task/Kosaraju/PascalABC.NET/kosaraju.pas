function kosaraju(g: List<Array of integer>): array of integer;
var
  size := g.Count;
  vis: array of boolean := new boolean[size];
  l: array of integer := new integer[size];
  c: array of integer := new integer[size];
  x := size;
  t: array of List<integer> := new List<integer>[size];

  procedure visit(u: integer);
  begin
    if not vis[u] then
    begin
      vis[u] := true;
      foreach var v in g[u] do
      begin
        visit(v);
        t[v].Add(u);
      end;
      dec(x);
      l[x] := u;
    end;
  end;

  procedure assign(u, root: integer);
  begin
    if vis[u] then
    begin
      vis[u] := false;
      c[u] := root;
      foreach var v in t[u] do assign(v, root);
    end;
  end;

begin
  for var i := 0 to t.Count - 1 do t[i] := new List<integer>;

  foreach var u in [0..size - 1] do visit(u);
  foreach var u in l do assign(u, u);
  result := c;
end;

begin
  var g := Lst(|1|, |2|, |0|, |1, 2, 4|, |3, 5|, |2, 6|, |5|, |4, 6, 7|);
  println(kosaraju(g));
end.
