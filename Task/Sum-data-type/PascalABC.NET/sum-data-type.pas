type
  [StructLayout(LayoutKind.Explicit)]
  Union = record
    [FieldOffset(0)]
    i: integer;
    [FieldOffset(0)]
    r: real;
    [FieldOffset(0)]
    d: DateTime;
  end;

begin
  var x: Union;
  x.i := 1;
  Println(x.i);
  x.r := 2.5;
  Println(x.r);
  x.d := DateTime.Now;
  Println(x.d);
  Println(sizeof(Union));
end.
