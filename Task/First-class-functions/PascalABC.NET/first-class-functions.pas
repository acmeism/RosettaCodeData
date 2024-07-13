function Cube(x: real) := x**3;
function CubeRoot(x: real) := x**(1/3);

function Composition<T>(f1,f2: T -> T): T -> T := x -> f1(f2(x));

begin
  var A := Arr(Sin,Cos,Cube);
  var B := Arr(ArcSin,ArcCos,CubeRoot);
  for var i:=0 to A.Length-1 do
    Println(Composition(A[i],B[i])(0.5));

  // Build-in composition f1 * f2
  foreach var (f1,f2) in A.Zip(B) do
  Println((f1 * f2)(0.5));
end.
