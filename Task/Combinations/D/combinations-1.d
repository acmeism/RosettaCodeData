import std.stdio;

T[][] comb(T)(in T[] arr, in int k) pure nothrow {
    if (k == 0) return [[]];
    typeof(return) result;
    foreach (i, x; arr)
        foreach (suffix; arr[i + 1 .. $].comb(k - 1))
            result ~= x ~ suffix;
    return result;
}

void main() {
    //import std.stdio: writeln;
    [0, 1, 2, 3].comb(2).writeln();
}
