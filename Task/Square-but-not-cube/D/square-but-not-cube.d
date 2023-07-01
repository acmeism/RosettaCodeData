import std.algorithm;
import std.range;
import std.stdio;

auto squareGen() {
    struct Gen {
        private int add = 3;
        private int curr = 1;

        bool empty() {
            return curr < 0;
        }

        auto front() {
            return curr;
        }

        void popFront() {
            curr += add;
            add += 2;
        }
    }

    return Gen();
}

auto cubeGen() {
    struct Gen {
        private int add1 = 7;
        private int add2 = 12;
        private int curr = 1;

        bool empty() {
            return curr < 0;
        }

        auto front() {
            return curr;
        }

        void popFront() {
            curr += add1;
            add1 += add2;
            add2 += 6;
        }
    }

    return Gen();
}

auto merge() {
    struct Gen {
        private auto sg = squareGen();
        private auto cg = cubeGen();

        bool empty() {
            return sg.empty || cg.empty;
        }

        auto front() {
            import std.typecons;
            if (sg.front == cg.front) {
                return tuple!("num", "isCube")(sg.front, true);
            } else {
                return tuple!("num", "isCube")(sg.front, false);
            }
        }

        void popFront() {
            while (true) {
                if (sg.front < cg.front) {
                    sg.popFront();
                    return;
                } else if (sg.front == cg.front) {
                    sg.popFront();
                    cg.popFront();
                    return;
                } else {
                    cg.popFront();
                }
            }
        }
    }

    return Gen();
}

void main() {
    foreach (p; merge.take(33)) {
        if (p.isCube) {
            writeln(p.num, " (also cube)");
        } else {
            writeln(p.num);
        }
    }
}
