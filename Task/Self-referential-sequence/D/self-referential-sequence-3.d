import core.stdc.stdio, core.stdc.stdlib;

struct MemoryPool(T, int MAX_BLOCK_BYTES=1 << 17) {
    static assert(!is(T == class),
                  "MemoryPool is designed for native data.");
    static assert(MAX_BLOCK_BYTES >= 1,
                  "MemoryPool: MAX_BLOCK_BYTES must be >= 1 bytes.");

    static struct Block {
        static assert(MAX_BLOCK_BYTES >= T.sizeof,
                      "MemoryPool: MAX_BLOCK_BYTES must be" ~
                      " bigger than a T.");
        static if ((T.sizeof * 5) > MAX_BLOCK_BYTES)
            pragma(msg, "MemoryPool: Block is very small.");

        T[(MAX_BLOCK_BYTES / T.sizeof)] items;
    }

    __gshared static Block*[] blocks;

    __gshared static T* nextFree, lastFree;

    static T* newItem() nothrow {
        if (nextFree >= lastFree) {
            blocks ~= cast(Block*)calloc(1, Block.sizeof);
            if (blocks[$ - 1] == null)
                exit(1);
            nextFree = blocks[$ - 1].items.ptr;
            lastFree = nextFree + Block.items.length;
        }

        return nextFree++;
    }

    static void freeAll() nothrow {
        foreach (block_ptr; blocks)
            free(block_ptr);
        blocks.length = 0;
        nextFree = null;
        lastFree = null;
    }
}

struct Rec { // Tree node
    int length;
    Rec*[10] p;
}

__gshared int nNodes;
__gshared Rec* rec_root;
__gshared MemoryPool!Rec recPool;

Rec* findRec(char* s, Rec* root) nothrow {
    int c;
    Rec* next;

    while (true) {
        c = *s;
        s++;
        if (!c)
            break;
        c -= '0';
        next = root.p[c];
        if (!next) {
            nNodes++;
            next = recPool.newItem();
            root.p[c] = next;
        }
        root = next;
    }
    return root;
}

void nextNum(char* s) nothrow {
    int[10] cnt;
    for (int i = 0; s[i]; i++)
        cnt[s[i] - '0']++;

    foreach_reverse (i; 0 .. 10) {
        if (!cnt[i])
            continue;
        s += sprintf(s, "%d%c", cnt[i], i + '0');
    }
}

int getLen(char* s, int depth) nothrow {
    auto r = findRec(s, rec_root);
    if (r.length > 0)
        return r.length;

    depth++;
    if (!r.length)
        r.length = -depth;
    else
        r.length += depth;

    nextNum(s);
    depth = 1 + getLen(s, depth);

    if (r.length <= 0)
        r.length = depth;
    return r.length;
}

void main() nothrow {
    enum MAXN = 1_000_000;

    int[100] longest;
    int nLongest, ml;
    char[32] buf;
    rec_root = recPool.newItem();

    foreach (i; 0 .. MAXN) {
        sprintf(buf.ptr, "%d", i);
        int l = getLen(buf.ptr, 0);
        if (l < ml)
            continue;
        if (l > ml) {
            nLongest = 0;
            ml = l;
        }
        longest[nLongest] = i;
        nLongest++;
    }

    printf("seq leng: %d\n\n", ml);
    foreach (i; 0 .. nLongest) {
        sprintf(buf.ptr, "%d", longest[i]);
        // print len+1 so we know repeating starts from when
        foreach (l; 0 .. ml + 1) {
            printf("%2d: %s\n", getLen(buf.ptr, 0), buf.ptr);
            nextNum(buf.ptr);
        }
        printf("\n");
    }

    printf("Allocated %d Rec tree nodes.\n", nNodes);
    //recPool.freeAll();
}
