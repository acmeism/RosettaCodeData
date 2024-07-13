begin
  var (a,b) := ReadInteger2;
  Println($'not {a} = {not a}');
  Println($'{a} and {b} = {a and b}');
  Println($'{a} or {b} = {a or b}');
  Println($'{a} xor {b} = {a xor b}');
  Println($'{a} shl {b} = {a shl b}');
  Println($'{a} shr {b} = {a shr b}');
end.
