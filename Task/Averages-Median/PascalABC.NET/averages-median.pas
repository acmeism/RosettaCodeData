##
function median(a: array of real): real;
begin
  var asort := a.Sorted.ToArray;
  var alen := a.Length;
  result := (asort[(alen - 1) div 2] + asort[alen div 2]) / 2;
end;

var a := arr(4.1, 5.6, 7.2, 1.7, 9.3, 4.4, 3.2);
println(a, 'median', median(a));
a := arr(4.1, 7.2, 1.7, 9.3, 4.4, 3.2);
println(a, 'median', median(a));
