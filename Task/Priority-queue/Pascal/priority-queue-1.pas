program PriorityQueueTest;

uses Classes;

Type
 TItem = record
    Priority:Integer;
    Value:string;
 end;

 PItem = ^TItem;

TPriorityQueue = class(Tlist)
 procedure Push(Priority:Integer;Value:string);
 procedure SortPriority();
 function Pop():String;
 function Empty:Boolean;
end;

{ TPriorityQueue }

procedure TPriorityQueue.Push(Priority:Integer;Value:string);
var
 Item: PItem;
begin
    new(Item);
    Item^.Priority := Priority;
    Item^.Value := Value;
    inherited Add(Item);
    SortPriority();
end;

procedure TPriorityQueue.SortPriority();
var
 i,j:Integer;
begin
 if(Count < 2) Then  Exit();

 for i:= 0 to Count-2 do
  for j:= i+1 to Count-1 do
    if ( PItem(Items[i])^.Priority > PItem(Items[j])^.Priority)then
      Exchange(i,j);
end;

function TPriorityQueue.Pop():String;
begin
 if count = 0  then
   Exit('');
 result := PItem(First)^.value;
 Dispose(PItem(First));
 Delete(0);
end;

function TPriorityQueue.Empty:Boolean;
begin
 Result := Count = 0;
end;

var
 Queue : TPriorityQueue;
begin
  Queue:= TPriorityQueue.Create();

  Queue.Push(3,'Clear drains');
  Queue.Push(4,'Feed cat');
  Queue.Push(5,'Make tea');
  Queue.Push(1,'Solve RC tasks');
  Queue.Push(2,'Tax return');

  while not Queue.Empty() do
   writeln(Queue.Pop());

  Queue.free;
end.
