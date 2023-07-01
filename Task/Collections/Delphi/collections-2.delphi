var
    // TLists can't be initialized or created in declaration scope
    List1, List2:TList<Integer>;
begin
    List1 := TList<Integer>.Create;
    List1.Add(1);
    list1.AddRange([2, 3]);
    List1.free;

    // TList can be initialized using a class derivative from TEnumerable, like it self
    List1 := TList<Integer>.Create;
    list1.AddRange([1,2, 3]);

    List2 := TList<Integer>.Create(list1);
    Writeln(List2[2]); // 3
    List1.free;
    List2.free;


    // Inline TList can be created in routine scope
    // only for version after 10.3 Tokyo
    var List3:= TList<Integer>.Create;
    List3.Add(2);
    List3.free;

    var List4: TList<Integer>:= TList<Integer>.Create;
    List4.free;
end;
