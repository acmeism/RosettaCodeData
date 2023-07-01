program Test;
{$mode objfpc}{$h+}
uses
  MyObjDef;

var
  MyObj: Variant;

begin
  MyObj := MyObjCreate;
  WriteLn(MyObj.Bark);
  WriteLn(MyObj.Moo);
  WriteLn(MyObj.Meow);
end.
