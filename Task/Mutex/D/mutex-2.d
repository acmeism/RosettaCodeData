import tango.core.Thread, tango.io.Stdout, tango.util.log.Trace;

class Synced {
    public synchronized int func (int input) {
        Trace.formatln("in {} at func enter: {}", input, foo);
        // stupid loop to consume some time
        int arg;
        for (int i = 0; i < 1000*input; ++i) {
            for (int j = 0; j < 10_000; ++j) arg += j;
        }
        foo += input;
        Trace.formatln("in {} at func exit: {}", input, foo);
        return arg;
    }
    private static int foo;
}

void main(char[][] args) {
    SimpleThread[] ht;
    Stdout.print( "Starting application..." ).newline;

    for (int i=0; i < 3; i++) {
        Stdout.print( "Starting thread for: " )(i).newline;
        ht ~= new SimpleThread(i+1);
        ht[i].start();
    }

    // wait for all threads
    foreach( s; ht )
        s.join();
}

class SimpleThread : Thread
{
    private int d_id;
    this (int id) {
        super (&run);
        d_id = id;
    }

    void run() {
        auto tested = new Synced;
        Trace.formatln ("in run() {}", d_id);
        tested.func(d_id);
    }
}
