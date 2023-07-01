import std.stdio, std.algorithm, std.range, std.numeric, queue_usage2;

struct SternBrocot {
    private auto sb = GrowableCircularQueue!uint(1, 1);
    enum empty = false;
    @property uint front() pure nothrow @safe @nogc {
        return sb.front;
    }
    uint popFront() pure nothrow @safe {
        sb.push(sb.front + sb[1]);
        sb.push(sb[1]);
        return sb.pop;
    }
}

void main() {
    SternBrocot().drop(50_000_000).front.writeln;
}
