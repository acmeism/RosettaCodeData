sub multiplicative-digital-root(Int $n) {
    return .elems - 1, .[.end]
        given cache($n, {[*] .comb} ... *.chars == 1)
}

for 123321, 7739, 893, 899998 {
    say "$_: ", .&multiplicative-digital-root;
}

for ^10 -> $d {
    say "$d : ", .[^5]
        given (1..*).grep: *.&multiplicative-digital-root[1] == $d;
}
