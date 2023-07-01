import core.stdc.stdlib;
import std.stdio;

void main() {
    int limit;
    write("Max number (>0): ");
    readf!"%d\n"(limit);
    if (limit <= 0) {
        writeln("The max number to consider must be greater than zero.");
        exit(1);
    }

    int terms;
    write("Terms (>0): ");
    readf!"%d\n"(terms);
    if (terms <= 0) {
        writeln("The number of terms to consider must be greater than zero.");
        exit(1);
    }

    int[] factors = new int[terms];
    string[] words = new string[terms];

    for (int i=0; i<terms; ++i) {
        write("Factor ", i+1, " and word: ");
        readf!"%d %s\n"(factors[i], words[i]);
        if (factors[i] <= 0) {
            writeln("The factor to consider must be greater than zero.");
            exit(1);
        }
    }

    foreach(n; 1..limit+1) {
        bool print = true;

        for (int i=0; i<terms; ++i) {
            if (n % factors[i] == 0) {
                write(words[i]);
                print = false;
            }
        }

        if (print) {
            writeln(n);
        } else {
            writeln();
        }
    }
}
