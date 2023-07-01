program ToposortTask;
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
  { returns True and the sorted sequence of nodes in aOutSeq if is acyclic,
    otherwise returns False and nil; uses Kahn's algorithm }
    function  TryToposort(out aOutSeq: TStringArray): Boolean;
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

function TDigraph.TryToposort(out aOutSeq: TStringArray): Boolean;
var
  q: TQueue<string>;
  p: TPair<string, TAdjList>;
  Node, ToRemove: string;
  Counter: SizeInt;
begin
  q := TQueue<string>.Create;
  SetLength(aOutSeq, Count);
  Counter := Pred(Count);
  for p in Self do
    if p.Value.InList.Count = 0 then
      q.Enqueue(p.Key);
  while q.Count > 0 do begin
    ToRemove := q.Dequeue;
    for Node in Items[ToRemove].OutList do
      with Items[Node] do begin
        InList.Remove(ToRemove);
        if InList.Count = 0 then
          q.Enqueue(Node);
      end;
    Remove(ToRemove);
    aOutSeq[Counter] := ToRemove;
    Dec(Counter);
  end;
  q.Free;
  Result := Count = 0;
  if not Result then
    aOutSeq := nil;
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
    WriteLn('circular dependency detected');
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
  Temp[1] := Temp[1] + ' dw04';
  TrySort(string.Join(LineEnding, Temp));
end.
