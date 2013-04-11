import std.stdio, std.random, std.conv, std.string;

void main() {
    auto tnum = text(uniform(1, 10));

    do write("What's next guess? ");
    while (readln().strip() != tnum);

    writeln("Yep, you guessed my ", tnum);
}
