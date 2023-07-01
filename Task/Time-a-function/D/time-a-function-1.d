import std.stdio, std.datetime;

int identity(int x) {
    return x;
}

int sum(int num) {
    foreach (i; 0 .. 100_000_000)
        num += i;
    return num;
}

double timeIt(int function(int) func, int arg) {
    StopWatch sw;
    sw.start();
    func(arg);
    sw.stop();
    return sw.peek().usecs / 1_000_000.0;
}

void main() {
    writefln("identity(4) takes %f6 seconds.", timeIt(&identity, 4));
    writefln("sum(4) takes %f seconds.", timeIt(&sum, 4));
}
