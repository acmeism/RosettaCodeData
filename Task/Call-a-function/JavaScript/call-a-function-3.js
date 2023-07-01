var make_adder = function(m) {
    return function(n) { return m + n }
};
var add42 = make_adder(42);
add42(10) // 52
