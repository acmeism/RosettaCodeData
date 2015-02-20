import rosettaCode.sortingAlgorithms.cocktailSort;

void main() {
    import std.stdio, std.algorithm, std.range, std.random;
    //generate 10 sorted random numbers in [0 .. 10)
    rndGen.take(10).map!(a=>a%10).array.cocktailSort.writeln();
}
