type
 MyClass = object
            variable: integer;
            constructor init;
            destructor done;
            procedure someMethod;
           end;

constructor MyClass.init;
 begin
  variable := 0;
 end;

procedure MyClass.someMethod;
 begin
  variable := 1;
 end;

var
 instance: MyClass; { as variable }
 pInstance: ^MyClass; { on free store }

begin
 { create instances }
 instance.init;
 new(pInstance, init); { alternatively: pInstance := new(MyClass, init); }

 { call method }
 instance.someMethod;
 pInstance^.someMethod;

 { get rid of the objects }
 instance.done;
 dispose(pInstance, done);
end;
