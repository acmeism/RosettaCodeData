import std.stdio, std.conv;

alias Tree = ulong,
      TreeList = Tree[],
      Offset = uint[32];

void listTees(in uint n, in ref Offset offset, in TreeList list) nothrow @nogc @safe {
    static void show(in Tree t, in uint len) nothrow @nogc @safe {
        foreach (immutable i; 0 .. len)
            putchar(t & (2 ^^ i) ? '(' : ')');
    }

    foreach (immutable i; offset[n] .. offset[n + 1]) {
        show(list[i], n * 2);
        putchar('\n');
    }
}

void append(in Tree t, ref TreeList list, ref uint len) pure nothrow @safe {
    if (len == list.length)
        list.length = list.length ? list.length * 2 : 2;
    list[len] = 1 | (t << 1);
    len++;
}

/**
Assemble tree from subtrees.

Params:
  n   = length of tree we want to make.
  t   = assembled parts so far.
  sl  = length of subtree we are looking at.
  pos = offset of subtree we are looking at.
  rem = remaining length to be put together.
*/
void assemble(in uint n, in Tree t, uint sl, uint pos, in uint rem, in ref Offset offset,
              ref TreeList list, ref uint len) pure nothrow @safe {
    if (!rem) {
        append(t, list, len);
        return;
    }

    if (sl > rem) { // Need smaller subtrees.
        sl = rem;
        pos = offset[sl];
    } else if (pos >= offset[sl + 1]) {
        // Used up sl-trees, try smaller ones.
        sl--;
        if (!sl)
            return;
        pos = offset[sl];
    }

    assemble(n, t << (2 * sl) | list[pos], sl, pos, rem - sl, offset, list, len);
    assemble(n, t, sl, pos + 1, rem, offset, list, len);
}

void makeTrees(in uint n, ref Offset offset,
               ref TreeList list, ref uint len) pure nothrow @safe {
    if (offset[n + 1])
        return;
    if (n)
        makeTrees(n - 1, offset, list, len);

    assemble(n, 0, n - 1, offset[n - 1], n - 1, offset, list, len);
    offset[n + 1] = len;
}

void main(in string[] args) {
    immutable uint n = (args.length == 2) ? args[1].to!uint : 5;
    if (n >= 25)
        return;

    Offset offset;
    offset[1] = 1;

    Tree[] list;
    uint len = 0;

    // Init 1-tree.
    append(0, list, len);

    makeTrees(n, offset, list, len);
    stderr.writefln("Number of %d-trees: %u", n, offset[n + 1] - offset[n]);
    listTees(n, offset, list);
}
