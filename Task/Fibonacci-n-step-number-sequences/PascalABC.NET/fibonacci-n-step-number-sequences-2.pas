// Fibonacci n-step number sequences. Nigel Galloway: September 8th., 2022
var nFib:=function(n:array of biginteger): (biginteger,array of biginteger)->(n.First,n[1:].Append(n.Sum).ToArray);
begin
  var fib:=unfold(nFib,1bi,1bi);              fib.Take(20).Println;
  var tri:=unfold(nFib,fib.Take(3).ToArray);  tri.Take(20).Println;
  var tet:=unfold(nFib,tri.Take(4).ToArray);  tet.Take(20).Println;
  var pen:=unfold(nFib,tet.Take(5).ToArray);  pen.Take(20).Println;
  var hex:=unfold(nFib,pen.Take(6).ToArray);  hex.Take(20).Println;
  var hep:=unfold(nFib,hex.Take(7).ToArray);  hep.Take(20).Println;
  var oct:=unfold(nFib,hep.Take(8).ToArray);  oct.Take(20).Println;
  var non:=unfold(nFib,oct.Take(9).ToArray);  non.Take(20).Println;
  var dec:=unfold(nFib,non.Take(10).ToArray); dec.Take(20).Println;
  var luc:=unfold(nFib,2bi,1bi);              luc.Take(20).Println;
end.
