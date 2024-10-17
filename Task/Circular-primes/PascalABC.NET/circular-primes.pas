##
function IsPrime(n: integer): boolean;
begin
  result := false;
  for var i := 2 to n.Sqrt.Floor do
    if n mod i = 0 then
      exit;
  result := true;
end;

function rotations(n: integer): sequence of integer;
begin
  var a := n.tostring;
  for var i := 1 to a.Length do
    yield (a[i:] + a[:i]).ToInteger;
end;

function isCircular(n: integer): boolean;
begin
  var rot := rotations(n);
  if rot.first = rot.min then
    result := rot.All(x -> isPrime(x));
end;

(2..1000_000).Where(x -> isCircular(x)).Take(19).Println;
