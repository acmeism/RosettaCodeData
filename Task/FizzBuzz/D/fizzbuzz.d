import std.stdio, std.algorithm, std.conv;

/// With if-else.
void fizzBuzz(in uint n) {
    foreach (immutable i; 1 .. n + 1)
        if (!(i % 15))
            "FizzBuzz".writeln;
        else if (!(i % 3))
            "Fizz".writeln;
        else if (!(i % 5))
            "Buzz".writeln;
        else
            i.writeln;
}

/// With switch case.
void fizzBuzzSwitch(in uint n) {
    foreach (immutable i; 1 .. n + 1)
        switch (i % 15) {
            case 0:
                "FizzBuzz".writeln;
                break;
            case 3, 6, 9, 12:
                "Fizz".writeln;
                break;
            case 5, 10:
                "Buzz".writeln;
                break;
            default:
                i.writeln;
        }
}

void fizzBuzzSwitch2(in uint n) {
    foreach (immutable i; 1 .. n + 1)
        (i % 15).predSwitch(
        0,       "FizzBuzz",
        3,       "Fizz",
        5,       "Buzz",
        6,       "Fizz",
        9,       "Fizz",
        10,      "Buzz",
        12,      "Fizz",
        /*else*/ i.text).writeln;
}

void main() {
    100.fizzBuzz;
    writeln;
    100.fizzBuzzSwitch;
    writeln;
    100.fizzBuzzSwitch2;
}
