import std.stdio, std.range, std.algorithm, std.conv;

bool isUpsideDown(int n ) {
    auto digits = n.text.map!"int(a)-48";
    foreach (a; zip(digits, digits.retro))
        if (a[0] + a[1] != 10)
            return false;
    return true;
}

void main() {
    int udCount = 0, n = 1;

    writeln("The first 50 upside-down numbers:");
    while (udCount <= 5000) {
        while (!isUpsideDown(n))
            n++;
        udCount++;
        if (udCount <= 50)
            writef("%5d%c", n, udCount % 10 == 0 ? '\n' : ' ');
        else if (udCount == 500)
            writef("\nFive hundredth: %d\n", n);
        else if (udCount == 5000)
            writef("Five thousandth: %d\n", n);
        n++;
    }
}
