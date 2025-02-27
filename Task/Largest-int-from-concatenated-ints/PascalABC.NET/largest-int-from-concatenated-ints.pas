##
function maxNum(x: array of integer): string;
begin
  var s := x.select(n -> n.tostring).ToList;
  sort(s, (x, y) -> (x > y));
  result := s.Aggregate((p, x) -> p + x);
end;

maxNum([1, 34, 3, 98, 9, 76, 45, 4]).println;
maxNum([54, 546, 548, 60]).println;
