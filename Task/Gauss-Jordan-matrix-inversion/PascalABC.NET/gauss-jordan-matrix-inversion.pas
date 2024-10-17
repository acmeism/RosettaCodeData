uses NumLibABC;

begin
  var A := new Matrix(3,3,1,2,3,4,1,6,7,8,9);
  'Original:'.Println;
  A.Println(10,5);
  'Inverse:'.Println;
  A.Inv.Println(10,5);
end.
