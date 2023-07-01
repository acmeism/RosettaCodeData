void main(string[] args)
{
    import core.thread, std;
    args.drop(1).map!(a => a.to!uint).parallel.each!((a)
    {
        Thread.sleep(dur!"msecs"(a));
        write(a, " ");
    });
}
