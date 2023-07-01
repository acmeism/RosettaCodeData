using System;

class Program {
    interface Func {
        int apply(int i);
    }

    interface FuncFunc {
        Func apply(Func f);
    }

    interface RecursiveFunc {
        Func apply(RecursiveFunc f);
    }

    class Y {
        class __1 : RecursiveFunc {
            class __2 : Func {
                readonly RecursiveFunc w;

                public __2(RecursiveFunc w) {
                    this.w = w;
                }

                public int apply(int x) {
                    return w.apply(w).apply(x);
                }
            }

            readonly FuncFunc f;

            public __1(FuncFunc f) {
                this.f = f;
            }

            public Func apply(RecursiveFunc w) {
                return f.apply(new __2(w));
            }
        }

        public static Func _(FuncFunc f) {
            __1 r = new __1(f);
            return r.apply(r);
        }
    }

    class __fib : FuncFunc {
        class __1 : Func {
            readonly Func f;

            public __1(Func f) {
                this.f = f;
            }

            public int apply(int n) {
                return
                    (n <= 2)
                  ? 1
                  : (f.apply(n - 1) + f.apply(n - 2));
            }

        }

        public Func apply(Func f) {
            return new __1(f);
        }
    }

    class __fac : FuncFunc {
        class __1 : Func {
            readonly Func f;

            public __1(Func f) {
                this.f = f;
            }

            public int apply(int n) {
                return
                    (n <= 1)
                  ? 1
                  : (n * f.apply(n - 1));
            }
        }

        public Func apply(Func f) {
            return new __1(f);
        }
    }

    static void Main(params String[] arguments) {
        Func fib = Y._(new __fib());
        Func fac = Y._(new __fac());

        Console.WriteLine("fib(10) = " + fib.apply(10));
        Console.WriteLine("fac(10) = " + fac.apply(10));
    }
}
