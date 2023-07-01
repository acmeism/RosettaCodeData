package require vectcl
namespace import vectcl::vexpr

set ans [vexpr {pi=acos(-1); exp(pi*1i) + 1}]
puts "e**(pi*i) = $ans"
