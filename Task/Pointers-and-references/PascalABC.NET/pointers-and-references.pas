type MyClass = class
public
  x: integer := 555;
end;

begin
  var pi: ^integer;
  New(pi);
  pi^ := 1023;
  var pb: ^byte;
  //pb := pi; // compiler error
  var p: pointer;
  p := pi;
  pb := p;
  Print(pb^); // byte representation of integer
  loop 3 do
  begin
    pb := pointer(integer(pb)+1); // analog of pb++
    Print(pb^);
  end;
  Println;
  var obj := new MyClass; // obj is a reference to object
  // All regferences in .NET are under control of garbage collection
  Println(obj);
  var obj1 := obj; // another reference to the same object
  obj1.x := 666;
  Println(obj);
  obj := nil; // zero reference
end.
