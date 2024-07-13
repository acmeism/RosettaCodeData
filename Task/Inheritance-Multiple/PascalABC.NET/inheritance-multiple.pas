type
  IMy1 = interface
    procedure My1;
  end;
  IMy2 = interface
    procedure My2;
  end;
  MyClass = class(IMy1,IMy2)
  public
    procedure My1 := Writeln('My1');
    procedure My2 := Writeln('My2');
  end;
  MyClassD = class(MyClass,IMy1,IMy2)
  end;

begin
  var my := new MyClassD;
  my.My1; my.My2;
end.
