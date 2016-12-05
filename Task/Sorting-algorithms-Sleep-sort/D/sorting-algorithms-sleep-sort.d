import core.thread, std.concurrency, std.datetime,
    std.stdio, std.algorithm, std.conv;

void main(string[] args)
{
    if (!args.length)
        return;

    foreach (number; args[1 .. $].map!(to!uint))
        spawn((uint num) {
            Thread.sleep(dur!"msecs"(10 * num));
            writef("%d ", num);
        }, number);

    thread_joinAll();
}
