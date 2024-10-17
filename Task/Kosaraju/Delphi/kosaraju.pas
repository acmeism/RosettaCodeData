program KosarajuApp;

uses
  System.SysUtils;

type
  TKosaraju = TArray<TArray<Integer>>;

var
  g: TKosaraju;

procedure Init();
begin
  SetLength(g, 8);
  g[0] := [1];
  g[1] := [2];
  g[2] := [0];
  g[3] := [1, 2, 4];
  g[4] := [3, 5];
  g[5] := [2, 6];
  g[6] := [5];
  g[7] := [4, 6, 7];
end;

procedure Println(vector: TArray<Integer>);
var
  i: Integer;
begin
  write('[');
  if (Length(vector) > 0) then
    for i := 0 to High(vector) do
    begin
      write(vector[i]);
      if (i < high(vector)) then
        write(', ');
    end;

  writeln(']');
end;

function Kosaraju(g: TKosaraju): TArray<Integer>;
var
  vis: TArray<Boolean>;
  L, c: TArray<Integer>;
  x: Integer;
  t: TArray<TArray<Integer>>;
  Visit: TProc<Integer>;
  u: Integer;
  Assign: TProc<Integer, Integer>;
begin
  // 1. For each vertex u of the graph, mark u as unvisited. Let L be empty.
  SetLength(vis, Length(g));
  SetLength(L, Length(g));
  x := Length(L);
  // index for filling L in reverse order
  SetLength(t, Length(g)); // transpose graph

  // 2. recursive subroutine:

  Visit := procedure(u: Integer)
    begin
      if (not vis[u]) then
      begin
        vis[u] := true;
        for var v in g[u] do
        begin
          Visit(v);
          t[v] := concat(t[v], [u]);
          // construct transpose
        end;

        dec(x);
        L[x] := u;
      end;
    end;

  // 2. For each vertex u of the graph do Visit(u)

  for u := 0 to High(g) do
  begin
    Visit(u);
  end;

  SetLength(c, Length(g)); // result, the component assignment

  // 3: recursive subroutine:

  Assign := procedure(u, root: Integer)
    begin
      if vis[u] then
      // repurpose vis to mean "unassigned"
      begin
        vis[u] := false;
        c[u] := root;

        for var v in t[u] do
          Assign(v, root);
      end;
    end;

  // 3: For each element u of L in order, do Assign(u,u)

  for u in L do
    Assign(u, u);

  Result := c;
end;

begin
  Init;
  Println(Kosaraju(g));
end.
