import std.array;
import std.random;
import std.range;
import std.stdio;
import std.traits;

bool playOptimal() {
    auto secrets = iota(100).array.randomShuffle();

    prisoner:
    foreach (p; 0..100) {
        auto choice = p;
        foreach (_; 0..50) {
            if (secrets[choice] == p) continue prisoner;
            choice = secrets[choice];
        }
        return false;
    }

    return true;
}

bool playRandom() {
    auto secrets = iota(100).array.randomShuffle();

    prisoner:
    foreach (p; 0..100) {
        auto choices = iota(100).array.randomShuffle();
        foreach (i; 0..50) {
            if (choices[i] == p) continue prisoner;
        }
        return false;
    }

    return true;
}

double exec(const size_t n, bool function() play) {
    size_t success = 0;
    for (int i = n; i > 0; i--) {
        if (play()) {
            success++;
        }
    }
    return 100.0 * success / n;
}

void main() {
    enum N = 1_000_000;
    writeln("# of executions: ", N);
    writefln("Optimal play success rate: %11.8f%%", exec(N, &playOptimal));
    writefln(" Random play success rate: %11.8f%%", exec(N, &playRandom));
}
