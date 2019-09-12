program Stack;
 {$IFDEF FPC}{$MODE DELPHI}{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}{$ENDIF}
 {$ASSERTIONS ON}
uses Generics.Collections;

var
  lStack: TStack<Integer>;
begin
  lStack := TStack<Integer>.Create;
  try
    lStack.Push(1);
    lStack.Push(2);
    lStack.Push(3);
    Assert(lStack.Peek = 3); // 3 should be at the top of the stack

    Write(lStack.Pop:2);   // 3
    Write(lStack.Pop:2);   // 2
    Writeln(lStack.Pop:2); // 1
    Assert(lStack.Count = 0, 'Stack is not empty'); // should be empty
  finally
    lStack.Free;
  end;
end.
