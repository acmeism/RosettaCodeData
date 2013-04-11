type
  Tcl = class
    dummy: longint;
  end;
var
  c1: cl;
begin
  c1:=Tcl.create;
...
  c1.destroy;
end;
