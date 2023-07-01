import core.thread;
import std.stdio;

void main() {
    new Thread({
        writeln("Spawned thread.");
    }).start;
    writeln("Main thread.");
}
