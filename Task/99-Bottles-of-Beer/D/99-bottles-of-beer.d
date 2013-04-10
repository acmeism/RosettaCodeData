import std.stdio;

void main() {
    int bottles = 99;

    while (bottles > 1) {
        writeln(bottles, " bottles of beer on the wall,");
        writeln(bottles, " bottles of beer.");
        writeln("Take one down, pass it around,");
        if (--bottles > 1) {
            writeln(bottles, " bottles of beer on the wall.\n");
        }
    }
    writeln("1 bottle of beer on the wall.\n");

    writeln("No more bottles of beer on the wall,");
    writeln("no more bottles of beer.");
    writeln("Go to the store and buy some more,");
    writeln("99 bottles of beer on the wall.");
}
