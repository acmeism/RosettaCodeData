using System;

static class Program {
    struct S {
        public int Start, Stop, Incr;
        public string Comment;
    }

    static readonly S[] examples = {
        new S{Start=-2, Stop=2, Incr=1, Comment="Normal"},
        new S{Start=-2, Stop=2, Incr=0, Comment="Zero increment"},
        new S{Start=-2, Stop=2, Incr=-1, Comment="Increments away from stop value"},
        new S{Start=-2, Stop=2, Incr=10, Comment="First increment is beyond stop value"},
        new S{Start=2, Stop=-2, Incr=1, Comment="Start more than stop: positive increment"},
        new S{Start=2, Stop=2, Incr=1, Comment="Start equal stop: positive increment"},
        new S{Start=2, Stop=2, Incr=-1, Comment="Start equal stop: negative increment"},
        new S{Start=2, Stop=2, Incr=0, Comment="Start equal stop: zero increment"},
        new S{Start=0, Stop=0, Incr=0, Comment="Start equal stop equal zero: zero increment"}
    };

    static int Main() {
        const int limit = 10;
        bool empty;
        for (int i = 0; i < 9; ++i) {
            S s = examples[i];
            Console.Write("{0}\n", s.Comment);
            Console.Write("Range({0:d}, {1:d}, {2:d}) -> [", s.Start, s.Stop, s.Incr);
            empty = true;
            for (int j = s.Start, c = 0; j <= s.Stop && c < limit; j += s.Incr, ++c) {
                Console.Write("{0:d} ", j);
                empty = false;
            }
            if (!empty) Console.Write("\b");
            Console.Write("]\n\n");
        }
        return 0;
    }
}
