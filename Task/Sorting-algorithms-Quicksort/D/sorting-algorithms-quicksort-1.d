import std.stdio : writefln, writeln;
import std.algorithm: filter;
import std.array;

T[] quickSort(T)(T[] xs) =>
  xs.length == 0 ? [] :
    xs[1 .. $].filter!(x => x< xs[0]).array.quickSort ~
    xs[0 .. 1] ~
    xs[1 .. $].filter!(x => x>=xs[0]).array.quickSort;

void main() =>
  [4, 65, 2, -31, 0, 99, 2, 83, 782, 1].quickSort.writeln;
