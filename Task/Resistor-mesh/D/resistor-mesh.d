import std.stdio, std.traits;

enum Node.FP differenceThreshold = 1e-40;

struct Node {
    alias FP = real;
    enum Kind : size_t { free, A, B }

    FP voltage = 0.0;

    /*const*/ private Kind kind = Kind.free;
    // Remove kindGet once kind is const.
    @property Kind kindGet() const pure nothrow @nogc {return kind; }
}

Node.FP iter(size_t w, size_t h)(ref Node[w][h] m) pure nothrow @nogc {
    static void enforceBoundaryConditions(ref Node[w][h] m)
    pure nothrow @nogc {
        m[1][1].voltage =  1.0;
        m[6][7].voltage = -1.0;
    }

    static Node.FP calcDifference(in ref Node[w][h] m,
                                  ref Node[w][h] d) pure nothrow @nogc {
        Node.FP total = 0.0;

        foreach (immutable i; 0 .. h) {
            foreach (immutable j; 0 .. w) {
                Node.FP v = 0.0;
                {
                    size_t n = 0;
                    if (i != 0)    { v += m[i - 1][j].voltage; n++; }
                    if (j != 0)    { v += m[i][j - 1].voltage; n++; }
                    if (i < h - 1) { v += m[i + 1][j].voltage; n++; }
                    if (j < w - 1) { v += m[i][j + 1].voltage; n++; }
                    v = m[i][j].voltage - v / n;
                }

                d[i][j].voltage = v;
                if (m[i][j].kindGet == Node.Kind.free)
                    total += v ^^ 2;
            }
        }

        return total;
    }

    Node[w][h] difference;

    while (true) {
        enforceBoundaryConditions(m);
        if (calcDifference(m, difference) < differenceThreshold)
            break;
        foreach (immutable i, const di; difference)
            foreach (immutable j, const ref dij; di)
                m[i][j].voltage -= dij.voltage;
    }

    Node.FP[EnumMembers!(Node.Kind).length] cur = 0.0;
    foreach (immutable i, const di; difference)
        foreach (immutable j, const ref dij; di)
            cur[m[i][j].kindGet] += dij.voltage *
                                   (!!i + !!j + (i < h-1) + (j < w-1));

    return (cur[Node.Kind.A] - cur[Node.Kind.B]) / 2.0;
}

void main() {
    enum size_t w = 10,
                h = w;
    Node[w][h] mesh;

    // Set A and B Nodes.
    mesh[1][1] = Node( 1.0, Node.Kind.A);
    mesh[6][7] = Node(-1.0, Node.Kind.B);

    writefln("R = %.19f", 2 / mesh.iter);
}
