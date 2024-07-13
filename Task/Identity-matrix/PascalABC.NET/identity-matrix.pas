begin
  var n := ReadInteger;
  var matrix: array [,] of integer := MatrGen(n,n,(i,j) -> i = j ? 1 : 0);
  matrix.Println
end.
