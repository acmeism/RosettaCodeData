uses System, System.Reflection;

type
  MyClass = class
  private
    auto property NumberPrivate: integer := 666;
  public
    auto property Number: integer := 3;
  end;

begin
  var flags := BindingFlags.Instance or BindingFlags.Static
            or BindingFlags.Public or BindingFlags.NonPublic
            or BindingFlags.DeclaredOnly;

  var obj := new MyClass;

  typeof(MyClass).GetProperties(flags).Select(p -> (p.Name,p.GetValue(obj))).PrintLines;
end.
