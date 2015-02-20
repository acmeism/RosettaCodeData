bool isHappy(int n) pure nothrow {
    int[int] past;

    while (true) {
        int total = 0;
        while (n > 0) {
            total += (n % 10) ^^ 2;
            n /= 10;
        }
        if (total == 1)
            return true;
        if (total in past)
            return false;
        n = total;
        past[total] = 0;
    }
}

void main() {
    import std.stdio, std.algorithm, std.range;

    int.max.iota.filter!isHappy.take(8).writeln;
}
