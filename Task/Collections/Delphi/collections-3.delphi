 var
    // TDictionary can't be initialized or created in declaration scope
    Dic1: TDictionary<string, Integer>;
begin
    Dic1 := TDictionary<string, Integer>.Create;
    Dic1.Add('one',1);
    Dic1.free;

    // Inline TDictionary can be created in routine scope
    // only for version after 10.3 Tokyo
    var Dic2:= TDictionary<string, Integer>.Create;
    Dic2.Add('one',1);
    Dic2.free;

    var Dic3: TDictionary<string, Integer>:= TDictionary<string, Integer>.Create.Create;
    Dic3.Add('one',1);
    Dic3.free;
end;
