bool isPrime2(It)(in It n) pure nothrow {
    // Adapted from: http://www.devx.com/vb2themax/Tip/19051
    // Test 1, 2, 3 and multiples of 2 and 3:
    if (n == 2 || n == 3)
        return true;
    else if (n < 2 || n % 2 == 0 || n % 3 == 0)
        return false;

    // We can now avoid to consider multiples of 2 and 3. This
    // can be done really simply by starting at 5 and
    // incrementing by 2 and 4 alternatively, that is:
    //   5, 7, 11, 13, 17, 19, 23, 25, 29, 31, 35, 37, ...
    // We don't need to go higher than the square root of the n.
    for (It div = 5, inc = 2; div ^^ 2 <= n; div += inc, inc = 6 - inc)
        if (n % div == 0)
            return false;

    return true;
}

void main() {
    import std.stdio, std.algorithm, std.range;

    iota(2, 40).filter!isPrime2.writeln;
}
