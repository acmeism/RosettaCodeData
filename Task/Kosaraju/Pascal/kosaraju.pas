program Kosaraju_SCC;
{$mode objfpc}{$modeswitch arrayoperators}
{$j-}{$coperators on}
type
  TDigraph = array of array of Integer;

procedure PrintComponents(const g: TDigraph);
var
  Visited: array of Boolean = nil;
  RevPostOrder: array of Integer = nil;
  gr: TDigraph = nil; //reversed graph
  Counter, Next: Integer;
  FirstItem: Boolean;

  procedure Dfs1(aNode: Integer);
  begin
    Visited[aNode] := True;
    for Next in g[aNode] do begin
      gr[Next] += [aNode];
      if not Visited[Next] then
        Dfs1(Next);
    end;
    RevPostOrder[Counter] := aNode;
    Dec(Counter);
  end;

  procedure Dfs2(aNode: Integer);
  begin
    Visited[aNode] := True;
    for Next in gr[aNode] do
      if not Visited[Next] then
        Dfs2(Next);
    if FirstItem then begin
      FirstItem := False;
      Write(aNode);
    end else
      Write(', ', aNode);
  end;

var
  Node: Integer;
begin
  SetLength(Visited, Length(g));
  SetLength(RevPostOrder, Length(g));
  SetLength(gr, Length(g));
  Counter := High(g);
  for Node := 0 to High(g) do
    if not Visited[Node] then
      Dfs1(Node);
  FillChar(Pointer(Visited)^, Length(Visited), 0);
  for Node in RevPostOrder do
    if not Visited[Node] then begin
      FirstItem := True;
      Write('[');
      Dfs2(Node);
      WriteLn(']');
    end;
end;

const
  g: TDigraph = (
    (1),
    (2),
    (0),
    (1, 2, 4),
    (3, 5),
    (2, 6),
    (5),
    (4, 6, 7)
  );
begin
  PrintComponents(g);
end.
