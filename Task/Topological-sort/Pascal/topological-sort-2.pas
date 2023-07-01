program ToposortTask;
{$mode delphi}
uses
  SysUtils, Generics.Collections;

type
  TDigraph = class(TObjectDictionary<string, THashSet<string>>)
    procedure AddNode(const s: string);
    procedure AddArc(const s, t: string);
    function  AdjList(const s: string): THashSet<string>;
  { returns True and the sorted sequence of nodes in aOutSeq if is acyclic,
    otherwise returns False and the first found cycle; uses DFS }
    function  TryToposort(out aOutSeq: TStringArray): Boolean;
  end;

procedure TDigraph.AddNode(const s: string);
begin
  if not ContainsKey(s) then
    Add(s, THashSet<string>.Create);
end;

procedure TDigraph.AddArc(const s, t: string);
begin
  AddNode(s);
  AddNode(t);
  if s <> t then
    Items[s].Add(t);
end;

function TDigraph.AdjList(const s: string): THashSet<string>;
begin
  if not TryGetValue(s, Result) then
    Result := nil;
end;

function TDigraph.TryToposort(out aOutSeq: TStringArray): Boolean;
var
  Parents: TDictionary<string, string>;// stores the traversal tree as pairs (Node, its predecessor)
  procedure ExtractCycle(const BackPoint: string; Prev: string);
  begin // just walk backwards through the traversal tree, starting from Prev until BackPoint is encountered
    with TList<string>.Create do begin
      Add(Prev);
      repeat
        Prev := Parents[Prev];
        Add(Prev);
      until Prev = BackPoint;
      Add(Items[0]);
      Reverse; //this is required since we moved backwards through the tree
      aOutSeq := ToArray;
      Free;
    end
  end;
var
  Visited,                 // set of already visited nodes
  Closed: THashSet<string>;// set of nodes whose subtree traversal is complete
  Counter: SizeInt = 0;
  function Dfs(const aNode: string): Boolean;// True means successful sorting,
  var                                        // False - found cycle
    Next: string;
  begin
    Visited.Add(aNode);
    for Next in AdjList(aNode) do
      if not Visited.Contains(Next) then begin
        Parents.Add(Next, aNode);
        if not Dfs(Next) then exit(False);
      end else
        if not Closed.Contains(Next) then begin//back edge found(i.e. cycle)
          ExtractCycle(Next, aNode);
          exit(False);
        end;
    Closed.Add(aNode);
    aOutSeq[Counter] := aNode;
    Inc(Counter);
    Result := True;
  end;
var
  Node: string;
begin
  SetLength(aOutSeq, Count);
  Visited := THashSet<string>.Create;
  Closed := THashSet<string>.Create;
  Parents := TDictionary<string, string>.Create;
  Result := True;
  for Node in Keys do
    if not Visited.Contains(Node) then
      if not Dfs(Node) then begin
        Result := False;
        break;
      end;
  Visited.Free;
  Closed.Free;
  Parents.Free;
end;

{ expects text separated by line breaks }
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

procedure TrySort(const aData: string);
var
  g: TDigraph;
  Sorted: TStringArray;
begin
  g := ParseRawData(aData);
  if g.TryToposort(Sorted) then
    WriteLn('success: ', LineEnding, string.Join(', ', Sorted))
  else
    WriteLn('circular dependency: ', LineEnding, string.Join('->', Sorted));
  g.Free;
end;

const
  ExampleData =
    'des_system_lib   std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee' + LineEnding +
    'dw01             ieee dw01 dware gtech'                                          + LineEnding +
    'dw02             ieee dw02 dware'                                                + LineEnding +
    'dw03             std synopsys dware dw03 dw02 dw01 ieee gtech'                   + LineEnding +
    'dw04             dw04 ieee dw01 dware gtech'                                     + LineEnding +
    'dw05             dw05 ieee dware'                                                + LineEnding +
    'dw06             dw06 ieee dware'                                                + LineEnding +
    'dw07             ieee dware'                                                     + LineEnding +
    'dware            ieee dware'                                                     + LineEnding +
    'gtech            ieee gtech'                                                     + LineEnding +
    'ramlib           std ieee'                                                       + LineEnding +
    'std_cell_lib     ieee std_cell_lib'                                              + LineEnding +
    'synopsys';
var
  Temp: TStringArray;

begin
  TrySort(ExampleData);
  WriteLn;
  //let's add a circular dependency
  Temp := ExampleData.Split([LineEnding], TStringSplitOptions.ExcludeEmpty);
  Temp[1] := Temp[1] + ' dw07';
  Temp[7] := Temp[7] + ' dw03';
  TrySort(string.Join(LineEnding, Temp));
end.
