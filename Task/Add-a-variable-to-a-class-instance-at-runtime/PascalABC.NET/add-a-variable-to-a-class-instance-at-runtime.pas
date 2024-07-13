type
  MyClass = class
    private
      dict := new Dictionary<string,object>;
    public
      procedure Add(name: string; value: object) := dict[name] := value;
      property Items[name: string]: object read dict[name]; default;
  end;

begin
  var obj := new MyClass;
  obj.Add('Name','PascalABC.NET');
  obj.Add('Age',16);
  Println(obj['Name'],obj['Age']);
  var obj1 := new MyClass;
  obj1.Add('X',2.3);
  obj1.Add('Y',3.8);
  Println(obj1['X'],obj1['Y']);
end.
