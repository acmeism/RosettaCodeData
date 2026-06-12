program TopLevel;
{$mode delphi}
uses
  SysUtils, Generics.Collections;

type
  TAdjList = class
    InList,                    // incoming arcs
    OutList: THashSet<string>; // outcoming arcs
    constructor Create;
    destructor Destroy; override;
  end;

  TDigraph = class(TObjectDictionary<string, TAdjList>)
    procedure AddNode(const s: string);
    procedure AddArc(const s, t: string);
    function  AdjList(const s: string): TAdjList;
  end;

constructor TAdjList.Create;
begin
  InList := THashSet<string>.Create;
  OutList := THashSet<string>.Create;
end;

destructor TAdjList.Destroy;
begin
  InList.Free;
  OutList.Free;
  inherited;
end;

procedure TDigraph.AddNode(const s: string);
begin
  if not ContainsKey(s) then
    Add(s, TAdjList.Create);
end;

procedure TDigraph.AddArc(const s, t: string);
begin
  AddNode(s);
  AddNode(t);
  if s <> t then begin
    Items[s].OutList.Add(t);
    Items[t].InList.Add(s);
  end;
end;

function TDigraph.AdjList(const s: string): TAdjList;
begin
  if not TryGetValue(s, Result) then
    Result := nil;
end;

function GetCompOrder(g: TDigraph; const aTarget: string): TStringArray;
var
  Stack: TList<string>;
  Visited: THashSet<string>;
  procedure Dfs(const aNode: string);
  var
    Next: string;
  begin
    Visited.Add(aNode);
    for Next in  g.AdjList(aNode).OutList do
      if not Visited.Contains(Next) then
        Dfs(Next);
    Stack.Add(aNode);
  end;
begin
  if not g.ContainsKey(aTarget) then exit([aTarget]);
  Stack := TList<string>.Create;
  Visited := THashSet<string>.Create;
  Dfs(aTarget);
  Visited.Free;
  Result := Stack.ToArray;
  Stack.Free;
end;

function GetTopLevels(g: TDigraph): TStringArray;
var
  List: TList<string>;
  p: TPair<string, TAdjList>;
begin
  List := TList<string>.Create;
  for p in g do
    with p.Value do
      if (InList.Count = 0) and (OutList.Count <> 0) then
        List.Add(p.Key);
  Result := List.ToArray;
  List.Free;
end;

function ParseRawData(const aData: string): TDigraph;
var
  Line, Curr, Node: string;
  FirstTerm: Boolean;
begin
  Result := TDigraph.Create([doOwnsValues]);
  for Line in aData.Split([LineEnding], TStringSplitOptions.ExcludeEmpty) do begin
    FirstTerm := True;
    for Curr in Line.Split([' '], TStringSplitOptions.ExcludeEmpty) do
      if FirstTerm then begin
        Node := Curr;
        Result.AddNode(Curr);
        FirstTerm := False;
      end else
        Result.AddArc(Node, Curr);
  end;
end;

const
  Data =
    'top1    des1 ip1 ip2'            + LineEnding +
    'top2    des1 ip2 ip3'            + LineEnding +
    'ip1     extra1 ip1a ipcommon'    + LineEnding +
    'ip2     ip2a ip2b ip2c ipcommon' + LineEnding +
    'des1    des1a des1b des1c'       + LineEnding +
    'des1a   des1a1 des1a2'           + LineEnding +
    'des1c   des1c1 extra1';
var
  g: TDigraph;
begin
  g := ParseRawData(Data);
  WriteLn('Top levels: ', string.Join(', ', GetTopLevels(g)));
  WriteLn;
  WriteLn('Compile order for top1:', LineEnding, string.Join(', ', GetCompOrder(g, 'top1')));
  WriteLn;
  WriteLn('Compile order for top2:', LineEnding, string.Join(', ', GetCompOrder(g, 'top2')));
  g.Free;
end.
