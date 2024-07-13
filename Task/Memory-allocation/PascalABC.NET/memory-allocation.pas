procedure ppp;
begin
  var i,j: integer; // i,j are allocated automatically on the stack when we call procedure
end;

begin
  ppp;
  var p: ^integer;
  New(p); // memory is allocated on the heap
  p^ := 666;
  Dispose(p); // explicit memory deallocation

  var ri := new integer[5]; // memory is allocated on the heap
  ri[0] := 555;
  ri := nil; // memory is controlled by .NET garbage collector
end.
