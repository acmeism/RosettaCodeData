program test;
{$mode objfpc}{$h+}
uses
  MyObjDef;

var
  MyObj: Variant;

begin
  MyObj := MyObjCreate;
  MyObj.Answer := 42;
  MyObj.Foo := 'Bar';
  MyObj.When := TDateTime(34121);
  WriteLn(MyObj.Answer);
  WriteLn(MyObj.Foo);
//check if variable names are case-insensitive, as it should be in Pascal
  WriteLn(MyObj.wHen);
end.
