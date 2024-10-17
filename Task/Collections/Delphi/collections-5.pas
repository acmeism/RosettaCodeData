var
    Stack1, Stack2: TStack<Integer>;
    List1:TList<Integer>;
begin
    Stack1:= TStack<Integer>.Create;
    Stack1.Push(1);
    Stack1.Push(2);
    Writeln(Stack1.Pop); // 2
    Writeln(Stack1.Pop); // 1
    Stack1.free;

    // TStack can be initialized using a class derivative from TEnumerable, like TList<T>
    List1 := TList<Integer>.Create;
    List1.Add(3);
    Stack2:= TStack<Integer>.Create(List1);
    Writeln(Stack2.Pop); // 3
    List1.free;
    Stack2.free;

    // Inline TStack can be created in routine scope
    // only for version after 10.3 Tokyo
    var Stack3:= TStack<Integer>.Create;
    Stack3.free;
end;
