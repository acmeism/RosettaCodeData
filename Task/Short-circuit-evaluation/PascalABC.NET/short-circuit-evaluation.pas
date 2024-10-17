function a(x:boolean): boolean;
begin
  'a called'.Println;
  result := x
end;

function b(x:boolean): boolean;
begin
  'b called'.Println;
  result := x
end;

begin
 var x := a(false) and b(true); // a called
 var y := a(true) or b(true)    // a called
end.
