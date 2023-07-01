import tango.io.Stdout;
import tango.time.Clock;

int identity (int x)
{
    return x;
}

int sum (int num)
{
    for (int i = 0; i < 1000000; i++)
      num += i;
    return num;
}

double timeIt(int function(int) func, int arg)
{
    long before = Clock.now.ticks;
    func(arg);
    return (Clock.now.ticks - before) / cast(double)TimeSpan.TicksPerSecond;
}

void main ()
{
    Stdout.format("Identity(4) takes {:f6} seconds",timeIt(&identity,4)).newline;
    Stdout.format("Sum(4) takes {:f6} seconds",timeIt(&sum,4)).newline;
}
