program QueueDefinition;

{$APPTYPE CONSOLE}

uses
  System.Generics.Collections;

type
  TQueue = System.Generics.Collections.TQueue<Integer>;

  TQueueHelper = class helper for TQueue
    function Empty: Boolean;
    function Pop: Integer;
    procedure Push(const NewItem: Integer);
  end;

{ TQueueHelper }

function TQueueHelper.Empty: Boolean;
begin
  Result := count = 0;
end;

function TQueueHelper.Pop: Integer;
begin
  Result := Dequeue;
end;

procedure TQueueHelper.Push(const NewItem: Integer);
begin
  Enqueue(NewItem);
end;

var
  Queue: TQueue;
  i: Integer;

begin
  Queue := TQueue.Create;

  for i := 1 to 1000 do
    Queue.push(i);

  while not Queue.Empty do
    Write(Queue.pop, ' ');
  Writeln;

  Queue.Free;
  Readln;
end.
