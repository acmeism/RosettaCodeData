import std.stdio;

real mean(Range)(Range r) {
    real sum = 0.0;
    int count;

    foreach (item; r) {
        sum += item;
        count++;
    }

    if (count == 0)
        return 0.0;
    else
        return sum / count;
}

void main() {
    int[] data;
    writeln("mean: ", data.mean());
    data = [3, 1, 4, 1, 5, 9];
    writeln("mean: ", data.mean());
}
