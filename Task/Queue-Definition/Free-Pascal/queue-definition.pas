program queue;
 {$IFDEF FPC}{$MODE DELPHI}{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}{$ENDIF}
 {$ASSERTIONS ON}
uses Generics.Collections;

var
  lQueue: TQueue<Integer>;
begin
  lQueue := TQueue<Integer>.Create;
  try
    lQueue.EnQueue(1);
    lQueue.EnQueue(2);
    lQueue.EnQueue(3);
    Write(lQueue.DeQueue:2);   // 1
    Write(lQueue.DeQueue:2);   // 2
    Writeln(lQueue.DeQueue:2); // 3
    Assert(lQueue.Count = 0, 'Queue is not empty'); // should be empty
  finally
    lQueue.Free;
  end;
end.
