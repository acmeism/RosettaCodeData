##
var empty := new List<integer>;
println(cartesian(|1, 2|, |3, 4|));
println(cartesian(|3, 4|, |1, 2|));
println(cartesian(|1, 2|, empty));
println(cartesian(empty, |1, 2|));
println(cartesian(|1776, 1789|, |7, 12|, |4, 14, 23|, |0, 1|));
println(cartesian(|1, 2, 3|, |30|, |500, 100|));
println(cartesian(|1, 2, 3|, empty, |500, 100|));
