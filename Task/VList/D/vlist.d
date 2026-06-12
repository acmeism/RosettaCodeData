import core.stdc.stdio: fprintf, stderr;
import core.stdc.stdlib: malloc, free, abort;

/// Uses C malloc and free to manage its memory.
/// Use only VList.alloc and VList.free.
struct VList(T) {
    static struct Sublist {
        Sublist* next;
        T[0] dataArr0;

        @property data() inout pure nothrow {
            return dataArr0.ptr;
        }

        static typeof(this)* alloc(in size_t len) nothrow {
            auto ptr = cast(typeof(this)*)malloc(typeof(this).sizeof +
                                                 T.sizeof * len);
            ptr.next = null;
            return ptr;
        }
    }

    // A dynamic array of pointers to growing buffers seems
    // better than a linked list of them.
    Sublist* head;
    size_t lastSize, ofs;

    static typeof(this)* alloc() nothrow {
        auto v = cast(typeof(this)*)malloc(VList.sizeof);
        enum startLength = 1;
        v.head = Sublist.alloc(startLength);
        v.lastSize = startLength;
        v.ofs = 0;
        return v;
    }

    void free() nothrow {
        while (this.head) {
            auto s = this.head.next;
            .free(this.head);
            this.head = s;
        }
        .free(&this);
    }

    @property size_t length() const nothrow {
        return this.lastSize * 2 - this.ofs - 2;
    }

    T* addr(in size_t idx) const nothrow {
        const(Sublist)* s = this.head;
        size_t top = this.lastSize;
        size_t i = idx + this.ofs;

        if (i + 2 >= (top << 1)) {
            fprintf(stderr, "!: idx %zd out of range\n", idx);
            abort();
        }
        while (s && i >= top) {
            s = s.next;
            i ^= top;
            top >>= 1;
        }
        return s.data + i;
    }

    T elem(in size_t idx) const nothrow {
        return *this.addr(idx);
    }

    // Currently dangerous.
    //T opIndex(in size_t idx) const nothrow {
    //    return elem(idx);
    //}

    T* prepend(in T x) nothrow {
        if (!this.ofs) {
            auto s = Sublist.alloc(this.lastSize << 1);
            if (s == null) {
                fprintf(stderr, "?: alloc failure\n");
                return null;
            }
            this.lastSize <<= 1;
            this.ofs = this.lastSize;
            s.next = this.head;
            this.head = s;
        }

        this.ofs--;
        auto p = this.head.data + this.ofs;
        *p = x;
        return p;
    }

    T popHead() nothrow {
        if (this.lastSize == 1 && this.ofs == 1) {
            fprintf(stderr, "!: empty list\n");
            abort();
        }

        auto x = this.head.data[this.ofs];
        this.ofs++;

        if (this.ofs == this.lastSize) {
            this.ofs = 0;
            if (this.lastSize > 1) {
                auto s = this.head;
                this.head = s.next;
                this.lastSize >>= 1;
                .free(s);
            }
        }

        return x;
    }

    // Range protocol is missing.
}


void main() {
    import std.stdio, std.bigint;
    enum N = 10;

    auto v = VList!BigInt.alloc;
    foreach (immutable i; 0 .. N)
        v.prepend(i.BigInt);

    writefln("v.length = %d", v.length);
    foreach (immutable i; 0 .. N)
        writefln("v[%d] = %s", i, v.elem(i));
    foreach (immutable i; 0 .. N)
        writefln("popHead: %s", v.popHead);

    v.free;
}
