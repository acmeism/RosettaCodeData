uses NumLibABC;

begin
  var A := new Matrix(4, 3,
          1, 2, 3,
          4, 5, 6,
          7, 8, 9,
          10, 11, 12);
  'Original:'.Println;
  A.Println(3, 0);
  'Transposed:'.Println;
  A.Transpose.Println(3, 0);
end.
