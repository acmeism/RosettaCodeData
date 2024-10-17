##
function gmean(n: sequence of real) :=
   power(n.aggregate((s, x) -> s * x), 1.0 / n.count);

function hmean(n: sequence of real) :=
   n.count / n.sum(x -> 1 / x);

var nums := (1..10).Select( x -> real(x));
nums.average.println;
gmean(nums).Println;
hmean(nums).Println;
