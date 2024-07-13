uses System.Numerics;

function DotProduct(v1,v2: Vector3): real
  := v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;

function CrossProduct(v1,v2: Vector3): Vector3
  := new Vector3(v1.y * v2.z - v1.z * v2.y,
                 v1.z * v2.x - v1.x * v2.z,
                 v1.x * v2.y - v1.y * v2.x);

function ScalarTripleProduct(a,b,c: Vector3): real
  := DotProduct(a, CrossProduct(b, c));

function VectorTripleProduct(a,b,c: Vector3): Vector3
  := CrossProduct(a, CrossProduct(b, c));


begin
  var a := new Vector3(3,4,5);
  var b := new Vector3(4,3,5);
  var c := new Vector3(-5,-12,-13);
  Writeln(DotProduct(a, b));
  Writeln(CrossProduct(a, b));
  Writeln(ScalarTripleProduct(a, b, c));
  Writeln(VectorTripleProduct(a, b, c));
end.
