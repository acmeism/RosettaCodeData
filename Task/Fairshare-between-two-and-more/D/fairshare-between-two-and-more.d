import std.array;
import std.stdio;

int turn(int base, int n) {
    int sum = 0;
    while (n != 0) {
        int re = n % base;
        n /= base;
        sum += re;
    }
    return sum % base;
}

void fairShare(int base, int count) {
    writef("Base %2d:", base);
    foreach (i; 0..count) {
        auto t = turn(base, i);
        writef(" %2d", t);
    }
    writeln;
}

void turnCount(int base, int count) {
    auto cnt = uninitializedArray!(int[])(base);
    cnt[] = 0;

    foreach (i; 0..count) {
        auto t = turn(base, i);
        cnt[t]++;
    }

    auto minTurn = int.max;
    auto maxTurn = int.min;
    int portion = 0;
    foreach (num; cnt) {
        if (num > 0) {
            portion++;
        }
        if (num < minTurn) {
            minTurn = num;
        }
        if (maxTurn < num) {
            maxTurn = num;
        }
    }

    writef("  With %d people: ", base);
    if (minTurn == 0) {
        writefln("Only %d have a turn", portion);
    } else if (minTurn == maxTurn) {
        writeln(minTurn);
    } else {
        writeln(minTurn," or ", maxTurn);
    }
}

void main() {
    fairShare(2, 25);
    fairShare(3, 25);
    fairShare(5, 25);
    fairShare(11, 25);

    writeln("How many times does each get a turn in 50000 iterations?");
    turnCount(191, 50000);
    turnCount(1377, 50000);
    turnCount(49999, 50000);
    turnCount(50000, 50000);
    turnCount(50001, 50000);
}
