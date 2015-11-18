program sum35;
//sum of all positive multiples of 3 or 5 below n

function cntSumdivisibleBelowN(n: Uint64;b:Uint64):Uint64;
var
  cnt : Uint64;
Begin
  cnt := (n-1) DIV b;
// Gauß summation formula * b
  cntSumdivisibleBelowN := (cnt*(cnt+1) DIV 2 ) *b;
end;
const
  n = 1000;

var
  sum: Uint64;
begin
  sum := cntSumdivisibleBelowN(n,3)+cntSumdivisibleBelowN(n,5);
//subtract double counted like 15
  sum := sum-cntSumdivisibleBelowN(n,3*5);
  writeln(sum);
end.
