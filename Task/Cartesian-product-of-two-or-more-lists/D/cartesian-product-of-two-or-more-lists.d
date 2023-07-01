import std.stdio;

void main() {
    auto a = listProduct([1,2], [3,4]);
    writeln(a);

    auto b = listProduct([3,4], [1,2]);
    writeln(b);

    auto c = listProduct([1,2], []);
    writeln(c);

    auto d = listProduct([], [1,2]);
    writeln(d);
}

auto listProduct(T)(T[] ta, T[] tb) {
    struct Result {
        int i, j;

        bool empty() {
            return i>=ta.length
                || j>=tb.length;
        }

        T[] front() {
            return [ta[i], tb[j]];
        }

        void popFront() {
            if (++j>=tb.length) {
                j=0;
                i++;
            }
        }
    }

    return Result();
}
