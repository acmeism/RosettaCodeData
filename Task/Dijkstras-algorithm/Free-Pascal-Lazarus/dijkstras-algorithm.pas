program SsspDemo;
{$mode delphi}
uses
  SysUtils, Generics.Collections, PQueue;

type
  TArc = record
    Target: string;
    Cost: Integer;
    constructor Make(const t: string; c: Integer);
  end;
  TDigraph = class
  strict private
    FGraph: TObjectDictionary<string, TList<TArc>>;
  public
  const
    INF_WEIGHT = MaxInt;
    constructor Create;
    destructor Destroy; override;
    procedure AddNode(const n: string);
    procedure AddArc(const s, t: string; c: Integer);
    function  AdjacencyList(const n: string): TList<TArc>;
    function  DijkstraSssp(const From: string; out PathTree: TDictionary<string, string>;
                           out Dist: TDictionary<string, Integer>): Boolean;
  end;

constructor TArc.Make(const t: string; c: Integer);
begin
  Target := t;
  Cost := c;
end;

function CostCmp(const L, R: TArc): Boolean;
begin
  Result := L.Cost > R.Cost;
end;

constructor TDigraph.Create;
begin
  FGraph := TObjectDictionary<string, TList<TArc>>.Create([doOwnsValues]);
end;

destructor TDigraph.Destroy;
begin
  FGraph.Free;
  inherited;
end;

procedure TDigraph.AddNode(const n: string);
begin
  if not FGraph.ContainsKey(n) then
    FGraph.Add(n, TList<TArc>.Create);
end;

procedure TDigraph.AddArc(const s, t: string; c: Integer);
begin
  AddNode(s);
  AddNode(t);
  if s <> t then
    FGraph.Items[s].Add(TArc.Make(t, c));
end;

function TDigraph.AdjacencyList(const n: string): TList<TArc>;
begin
  if not FGraph.TryGetValue(n, Result) then
    Result := nil;
end;

function TDigraph.DijkstraSssp(const From: string; out PathTree: TDictionary<string, string>;
  out Dist: TDictionary<string, Integer>): Boolean;
var
  q: TPriorityQueue<TArc>;
  Reached: THashSet<string>;
  Handles: TDictionary<string, q.THandle>;
  Next, Arc, Relax: TArc;
  h: q.THandle = -1;
  k: string;
begin
  if not FGraph.ContainsKey(From) then exit(False);
  Reached := THashSet<string>.Create;
  Handles := TDictionary<string, q.THandle>.Create;
  Dist := TDictionary<string, Integer>.Create;
  for k in FGraph.Keys do
    Dist.Add(k, INF_WEIGHT);
  PathTree := TDictionary<string, string>.Create;
  q := TPriorityQueue<TArc>.Create(@CostCmp);
  PathTree.Add(From, '');
  Next := TArc.Make(From, 0);
  repeat
    Reached.Add(Next.Target);
    Dist[Next.Target] := Next.Cost;
    for Arc in AdjacencyList(Next.Target) do
      if not Reached.Contains(Arc.Target)then
        if Handles.TryGetValue(Arc.Target, h) then begin
          Relax := q.GetValue(h);
          if Arc.Cost + Next.Cost < Relax.Cost then begin
            q.Update(h, TArc.Make(Relax.Target, Arc.Cost + Next.Cost));
            PathTree[Arc.Target] := Next.Target;
          end
        end else begin
          Handles.Add(Arc.Target, q.Push(TArc.Make(Arc.Target, Arc.Cost + Next.Cost)));
          PathTree.Add(Arc.Target, Next.Target);
        end;
  until not q.TryPop(Next);
  Reached.Free;
  Handles.Free;
  q.Free;
  Result := True;
end;

function ExtractPath(PathTree: TDictionary<string, string>; n: string): TStringArray;
begin
  if not PathTree.ContainsKey(n) then exit(nil);
  with TList<string>.Create do begin
    repeat
      Add(n);
      n := PathTree[n];
    until n = '';
    Reverse;
    Result := ToArray;
    Free;
  end;
end;

const
  PathFmt = 'shortest path from "%s" to "%s": %s (cost = %d)';
var
  g: TDigraph;
  Path: TDictionary<string, string>;
  Dist: TDictionary<string, Integer>;
begin
  g := TDigraph.Create;
  g.AddArc('a', 'b',  7); g.AddArc('a', 'c',  9); g.AddArc('a', 'f', 14);
  g.AddArc('b', 'c', 10); g.AddArc('b', 'd', 15); g.AddArc('c', 'd', 11);
  g.AddArc('c', 'f',  2); g.AddArc('d', 'e',  6); g.AddArc('e', 'f',  9);
  g.DijkstraSssp('a', Path, Dist);
  WriteLn(Format(PathFmt, ['a', 'e', string.Join('->', ExtractPath(Path, 'e')), Dist['e']]));
  WriteLn(Format(PathFmt, ['a', 'f', string.Join('->', ExtractPath(Path, 'f')), Dist['f']]));
  g.Free;
  Path.Free;
  Dist.Free;
  readln;
end.
