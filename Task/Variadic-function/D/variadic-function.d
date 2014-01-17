import std.stdio, std.algorithm;

void printAll(TyArgs...)(TyArgs args) {
    foreach (el; args)
        writeln(el);
}

// Typesafe variadic function for dynamic array
void showSum1(int[] items...) {
    writeln(reduce!q{a + b}(0, items));
}

// Typesafe variadic function for fixed size array
void showSum2(int[4] items...) {
    writeln(reduce!q{a + b}(0, items));
}

void main() {
    printAll(4, 5.6, "Rosetta", "Code", "is", "awesome");
    writeln();
    showSum1(1, 3, 50);
    showSum2(1, 3, 50, 10);
}
