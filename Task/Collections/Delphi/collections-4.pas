var
    Queue1, Queue2: TQueue<Integer>;
    List1:TList<Integer>;
begin
    Queue1 := TQueue<Integer>.Create;
    Queue1.Enqueue(1);
    Queue1.Enqueue(2);
    Writeln(Queue1.Dequeue); // 1
    Writeln(Queue1.Dequeue); // 2
    Queue1.free;

    // TQueue can be initialized using a class derivative from TEnumerable, like TList<T>
    List1 := TList<Integer>.Create;
    List1.Add(3);
    Queue2:= TQueue<Integer>.Create(List1);
    Writeln(Queue2.Dequeue); // 3
    List1.free;
    Queue2.free;

    // Inline TQueue can be created in routine scope
    // only for version after 10.3 Tokyo
    var Queue3 := TQueue<Integer>.Create;
    Queue3.free;
end;
