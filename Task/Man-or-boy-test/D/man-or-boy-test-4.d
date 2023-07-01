import std.stdio;

interface B {
    int run();
}

int A(int k, int x1, int x2, int x3, int x4, int x5) {
    B mb(int a) {
        return new class() B {
            int run() {
                return a;
            }
        };
    }

    return A(k, mb(x1), mb(x2), mb(x3), mb(x4), mb(x5));
}

int A(int k, B x1, B x2, B x3, B x4, B x5) {
    if (k <= 0) {
        return x4.run() + x5.run();
    } else {
        return (new class() B {
            int m;

            this() {
                this.m = k;
            }

            int run() {
                m--;
                return A(m, this, x1, x2, x3, x4);
            }
        }).run();
    }
}

void main() {
    writeln(A(10, 1, -1, -1, 1, 0));
}
