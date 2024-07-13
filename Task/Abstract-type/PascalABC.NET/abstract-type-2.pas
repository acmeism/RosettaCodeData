type
  IMyInterface = interface
    procedure Proc1;
    procedure Proc2;
  end;
  MyClass = class(IMyInterface)
    public
      procedure Proc1;
      begin
        Print(1);
      end;
      procedure Proc2;
      begin
        Print(2);
      end;
  end;

begin
  var a: IMyInterface := new MyClass;
  a.Proc1;
  a.Proc2;
end.
