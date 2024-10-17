uses NumLibABC;

begin
  var A := new Matrix(4, 2, 1, 2, 3, 4, 5, 6, 7, 8);
  var B := new Matrix(2, 3, 1, 2, 3, 4, 5, 6);
  var C := A * B;
  'Matrix A:'.Println;
  A.Println(2, 0);
  'Matrix B:'.Println;
  B.Println(2, 0);
  'Matrix A * B:'.Println;
  C.Println(3, 0);
end.
