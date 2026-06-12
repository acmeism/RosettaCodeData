import std.stdio, std.file, std.string, std.algorithm, std.array;

int[] frequBounds = [4, 8, 12, 16, 25, int.max];
int[6] frequ;

void main() {
    auto data = readText("data.txt").splitLines.map!"a.to!float";

    data.splitWhen!"a < b".map!array
        .map!"100 * (a[0] - a[$-1]) / a[0]"
        .filter!"a > 0"
        .map!(x => frequBounds.countUntil!(a => a > x))
        .each!(a => frequ[a]++);

    writeln("    Bin       Count");
    writeln("===================");
    writefln("( 0%% ,  4%%) %5d", frequ[0]);
    for (int i = 1; i < 5; i++)
        writefln("[%2d%% , %2d%%)%6d", frequBounds[i-1], frequBounds[i], frequ[i]);
    writefln("[25%% , inf) %5d", frequ[5]);
}
