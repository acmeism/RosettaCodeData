type MyInt = class
  i: integer;
  constructor (ii: integer) := i := ii;
  static function operator implicit(i: integer): MyInt := new MyInt(i);
end;

begin
  var ssi: shortint := 1;
  var si: smallint := ssi;
  var i: integer := si;
  var i64: int64 := i;
  var my: MyInt := i;
end.
