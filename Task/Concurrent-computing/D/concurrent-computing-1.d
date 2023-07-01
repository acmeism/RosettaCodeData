import std.stdio, std.random, std.parallelism, core.thread, core.time;

void main() {
    foreach (s; ["Enjoy", "Rosetta", "Code"].parallel(1)) {
        Thread.sleep(uniform(0, 1000).dur!"msecs");
        s.writeln;
    }
}
