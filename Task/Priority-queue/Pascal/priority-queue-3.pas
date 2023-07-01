unit PQueue;
{$mode objfpc}{$h+}{$b-}
interface
uses
  SysUtils;

type
  EPqError = class(Exception);

  generic TPriorityQueue<T> = class
  public
  type
    TComparer = function(const L, R: T): Boolean;
    THandle   = type SizeInt;
  const
    NULL_HANDLE = THandle(-1);
  strict private
  type
    TNode = record
      Data: T;
      HeapIndex: SizeInt;
    end;
  const
    INIT_SIZE          = 16;
    NULL_INDEX         = SizeInt(-1);
    SEUndefComparer    = 'Undefined comparer';
    SEInvalidHandleFmt = 'Invalid handle value(%d)';
    SEAccessEmpty      = 'Cannot access an empty queue item';
  var
    FNodes: array of TNode;
    FHeap: array of SizeInt;
    FCount,
    FStackTop: SizeInt;
    FCompare: TComparer;
    procedure CheckEmpty;
    procedure Expand;
    function  NodeAdd(const aValue: T; aIndex: SizeInt): SizeInt;
    function  NodeRemove(aIndex: SizeInt): T;
    function  StackPop: SizeInt;
    procedure StackPush(aIdx: SizeInt);
    procedure PushUp(Idx: SizeInt);
    procedure SiftDown(Idx: SizeInt);
    function  DoPop: T;
  public
    constructor Create(c: TComparer);
    function  IsEmpty: Boolean;
    procedure Clear;
    function  Push(const v: T): THandle;
    function  Pop: T;
    function  TryPop(out v: T): Boolean;
    function  Peek: T;
    function  TryPeek(out v: T): Boolean;
    function  GetValue(h: THandle): T;
    procedure Update(h: THandle; const v: T);
    property  Count: SizeInt read FCount;
  end;

implementation

procedure TPriorityQueue.CheckEmpty;
begin
  if Count = 0 then raise EPqError.Create(SEAccessEmpty);
end;

procedure TPriorityQueue.Expand;
begin
  if Length(FHeap) < INIT_SIZE then begin
    SetLength(FHeap, INIT_SIZE);
    SetLength(FNodes, INIT_SIZE)
  end
  else begin
    SetLength(FHeap, Length(FHeap) * 2);
    SetLength(FNodes, Length(FNodes) * 2);
  end;
end;

function TPriorityQueue.NodeAdd(const aValue: T; aIndex: SizeInt): SizeInt;
begin
  if FStackTop <> NULL_INDEX then
    Result := StackPop
  else
    Result := FCount;
  FNodes[Result].Data := aValue;
  FNodes[Result].HeapIndex := aIndex;
  Inc(FCount);
end;

function TPriorityQueue.NodeRemove(aIndex: SizeInt): T;
begin
  StackPush(aIndex);
  Result := FNodes[aIndex].Data;
end;

function TPriorityQueue.StackPop: SizeInt;
begin
  Result := FStackTop;
  if Result <> NULL_INDEX then begin
    FStackTop := FNodes[Result].HeapIndex;
    FNodes[Result].HeapIndex := NULL_INDEX;
  end;
end;

procedure TPriorityQueue.StackPush(aIdx: SizeInt);
begin
  FNodes[aIdx].HeapIndex := FStackTop;
  FStackTop := aIdx;
end;

procedure TPriorityQueue.PushUp(Idx: SizeInt);
var
  Prev, Curr: SizeInt;
begin
  Prev := (Idx - 1) shr 1;
  Curr := FHeap[Idx];
  while(Idx > 0) and FCompare(FNodes[FHeap[Prev]].Data, FNodes[Curr].Data) do begin
    FHeap[Idx] := FHeap[Prev];
    FNodes[FHeap[Prev]].HeapIndex := Idx;
    Idx := Prev;
    Prev := (Prev - 1) shr 1;
  end;
  FHeap[Idx] := Curr;
  FNodes[Curr].HeapIndex := Idx;
end;

procedure TPriorityQueue.SiftDown(Idx: SizeInt);
var
  Next, Sifted: SizeInt;
begin
  if Count < 2 then exit;
  Next := Idx*2 + 1;
  Sifted := FHeap[Idx];
  while Next < Count do begin
    if(Next+1 < Count)and FCompare(FNodes[FHeap[Next]].Data, FNodes[FHeap[Next+1]].Data)then Inc(Next);
    if not FCompare(FNodes[Sifted].Data, FNodes[FHeap[Next]].Data) then break;
    FHeap[Idx] := FHeap[Next];
    FNodes[FHeap[Next]].HeapIndex := Idx;
    Idx := Next;
    Next := Next*2 + 1;
  end;
  FHeap[Idx] := Sifted;
  FNodes[Sifted].HeapIndex := Idx;
end;

function TPriorityQueue.DoPop: T;
begin
  Result := NodeRemove(FHeap[0]);
  Dec(FCount);
  if Count > 0 then begin
    FHeap[0] := FHeap[Count];
    SiftDown(0);
  end;
end;

constructor TPriorityQueue.Create(c: TComparer);
begin
  if c = nil then raise EPqError.Create(SEUndefComparer);
  FCompare := c;
  FStackTop := NULL_INDEX;
end;

function TPriorityQueue.IsEmpty: Boolean;
begin
  Result := Count = 0;
end;

procedure TPriorityQueue.Clear;
begin
  FNodes := nil;
  FHeap := nil;
  FCount := 0;
  FStackTop := NULL_INDEX;
end;

function TPriorityQueue.Push(const v: T): THandle;
var
  InsertPos: SizeInt;
begin
  if Count = Length(FHeap) then Expand;
  InsertPos := Count;
  Result := NodeAdd(v, InsertPos);
  FHeap[InsertPos] := Result;
  if InsertPos > 0 then PushUp(InsertPos);
end;

function TPriorityQueue.Pop: T;
begin
  CheckEmpty;
  Result := DoPop;
end;

function TPriorityQueue.TryPop(out v: T): Boolean;
begin
  if Count = 0 then exit(False);
  v := DoPop;
  Result := True;
end;

function TPriorityQueue.Peek: T;
begin
  CheckEmpty;
  Result := FNodes[FHeap[0]].Data;
end;

function TPriorityQueue.TryPeek(out v: T): Boolean;
begin
  if Count = 0 then exit(False);
  v := FNodes[FHeap[0]].Data;
  Result := True;
end;

function TPriorityQueue.GetValue(h: THandle): T;
begin
  if SizeUInt(h) < SizeUInt(Length(FHeap)) then
    Result := FNodes[h].Data
  else
    raise EPqError.CreateFmt(SEInvalidHandleFmt, [h]);
end;

procedure TPriorityQueue.Update(h: THandle; const v: T);
begin
  if SizeUInt(h) < SizeUInt(Length(FHeap)) then begin
    if FCompare(FNodes[h].Data, v) then begin
      FNodes[h].Data := v;
      PushUp(FNodes[h].HeapIndex);
    end else
      if FCompare(v, FNodes[h].Data) then begin
        FNodes[h].Data := v;
        SiftDown(FNodes[h].HeapIndex);
      end;
  end else
    raise EPqError.CreateFmt(SEInvalidHandleFmt, [h]);
end;

end.
