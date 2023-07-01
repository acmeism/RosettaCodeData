import core.stdc.signal;
import core.thread;
import std.concurrency;
import std.datetime.stopwatch;
import std.stdio;

__gshared int gotint = 0;
extern(C) void handleSigint(int sig) nothrow @nogc @system {
    /*
     * Signal safety: It is not safe to call clock(), printf(),
     * or exit() inside a signal handler. Instead, we set a flag.
     */
    gotint = 1;
}

void main() {
    auto sw = StopWatch(AutoStart.yes);
    signal(SIGINT, &handleSigint);
    for (int i=0; !gotint;) {
        Thread.sleep(500_000.usecs);
        if (gotint) {
            break;
        }
        writeln(++i);
    }
    sw.stop();
    auto td = sw.peek();
    writeln("Program has run for ", td);
}
