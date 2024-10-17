uses NumLibABC;

function operator **(m: Matrix; exp: integer): Matrix;
extensionmethod;
begin
  Assert(m.ColCount = m.RowCount, 'Matrix must be square.');
  Assert(exp >= 0, 'Negative exponents not supported');
  result := Matrix.Diag(m.RowCount, 1);
  loop exp do result := result * m;
end;

begin
  var A := new Matrix(2, 2, 1, 1, 1, 0);
  'Original: '.Println;
  A.Println;
  A := A ** 10;
  'Raised to the power of 10: '.Println;
  A.Println;
end.
