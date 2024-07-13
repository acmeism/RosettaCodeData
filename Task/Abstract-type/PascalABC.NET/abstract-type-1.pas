type
  MyAbstract = abstract class
    public
      procedure Proc1; abstract;
      procedure Proc2;
      begin
      end;
  end;
  MyClass = class(MyAbstract)
    public
      procedure Proc1; override;
      begin
      end;
  end;


begin
  var a := new MyClass;
  a.Proc1;
end.
