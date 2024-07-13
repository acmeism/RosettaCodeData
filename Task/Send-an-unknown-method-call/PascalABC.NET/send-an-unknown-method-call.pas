type MyClass = class
public
  procedure Hello := Write('Hello');
end;

begin
  var obj := new MyClass;
  var mi := typeof(MyClass).GetMethod('Hello');
  mi.Invoke(obj,new object[0])
end.
