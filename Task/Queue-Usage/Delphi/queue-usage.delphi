program QueueUsage;

{$APPTYPE CONSOLE}

uses Generics.Collections;

var
  lStringQueue: TQueue<string>;
begin
  lStringQueue := TQueue<string>.Create;
  try
    lStringQueue.Enqueue('First');
    lStringQueue.Enqueue('Second');
    lStringQueue.Enqueue('Third');

    Writeln(lStringQueue.Dequeue);
    Writeln(lStringQueue.Dequeue);
    Writeln(lStringQueue.Dequeue);

    if lStringQueue.Count = 0 then
      Writeln('Queue is empty.');
  finally
    lStringQueue.Free;
  end
end.
