program Stack;

{$APPTYPE CONSOLE}

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

    Writeln(lStack.Pop); // 3
    Writeln(lStack.Pop); // 2
    Writeln(lStack.Pop); // 1
    Assert(lStack.Count = 0); // should be empty
  finally
    lStack.Free;
  end;
end.
