import std.range.primitives;
import std.stdio;

// An output range for writing the elements of the example ranges
struct OutputWriter {
    void put(E)(E e) if (!isInputRange!E) {
        stdout.write(e);
    }
}

void main() {
    import std.range : only;
    merge2(OutputWriter(), only(1,3,5,7), only(2,4,6,8));
    writeln("\n---------------");
    mergeN(OutputWriter(), only(1,4,7), only(2,5,8), only(3,6,9));
    writeln("\n---------------");
    mergeN(OutputWriter(), only(1,2,3));
}

/+ Write the smallest element from r1 and r2 until both ranges are empty +/
void merge2(IN,OUT)(OUT sink, IN r1, IN r2)
if (isInputRange!IN && isOutputRange!(OUT, ElementType!IN)) {
    import std.algorithm : copy;

    while (!r1.empty && !r2.empty) {
        auto a = r1.front;
        auto b = r2.front;
        if (a<b) {
            sink.put(a);
            r1.popFront;
        } else {
            sink.put(b);
            r2.popFront;
        }
    }
    copy(r1, sink);
    copy(r2, sink);
}

/+ Write the smallest element from the sources until all ranges are empty +/
void mergeN(OUT,IN)(OUT sink, IN[] source ...)
if (isInputRange!IN && isOutputRange!(OUT, ElementType!IN)) {
    ElementType!IN value;
    bool done, hasValue;
    int idx;

    do {
        hasValue = false;
        done = true;
        idx = -1;

        foreach(i,r; source) {
            if (!r.empty) {
                if (hasValue) {
                    if (r.front < value) {
                        value = r.front;
                        idx = i;
                    }
                } else {
                    hasValue = true;
                    value = r.front;
                    idx = i;
                }
            }
        }

        if (idx > -1) {
            sink.put(source[idx].front);
            source[idx].popFront;
            done = false;
        }
    } while (!done);
}
