import std.stdio, std.conv, std.datetime, std.array, core.thread;

final class SleepSorter: Thread {
    private immutable uint val;

    this(in uint n) /*pure nothrow @safe*/ {
        super(&run);
        val = n;
    }

    private void run() {
        Thread.sleep(dur!"msecs"(1000 * val));
        writef("%d ", val);
    }
}

void main(in string[] args) {
    if (!args.empty)
        foreach (const arg; args[1 .. $])
            new SleepSorter(arg.to!uint).start;
}
