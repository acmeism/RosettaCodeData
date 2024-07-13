type MyEnum = (One, Two = 2, Three = 3);

begin
  var my: MyEnum := One;
  Print(my);
end.
