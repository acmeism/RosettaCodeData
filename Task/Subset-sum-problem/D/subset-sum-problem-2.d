import std.stdio, std.algorithm;

enum showAllSolutions = true;

struct Item { string data; int weight; }
struct Sum { int sum; uint mask; }

immutable Item[] em = [
    {"alliance",  -624},  {"archbishop",  -915},  {"balm",        397},
    {"bonnet",     452},  {"brute",        870},  {"centipede",  -658},
    {"cobol",      362},  {"covariate",    590},  {"departure",   952},
    {"deploy",      44},  {"diophantine",  645},  {"efferent",     54},
    {"elysee",    -326},  {"eradicate",    376},  {"escritoire",  856},
    {"exorcism",  -983},  {"fiat",         170},  {"filmy",      -874},
    {"flatworm",   503},  {"gestapo",      915},  {"infra",      -847},
    {"isis",      -982},  {"lindholm",     999},  {"markham",     475},
    {"mincemeat", -880},  {"moresby",      756},  {"mycenae",     183},
    {"plugging",  -266},  {"smokescreen",  423},  {"speakeasy",  -745},
    {"vein",       813}];

Sum[] mkSums(in Item[] p, in size_t n, in size_t shift) {
    auto r = new Sum[1 << n];
    foreach (immutable i; 0 .. n)
        r[1 << i].sum = p[i].weight;

    foreach (immutable i, ref ri; r) {
        immutable size_t b = i & -int(i);
        ri = Sum(r[i & ~b].sum + r[b].sum, i << shift);
    }

    return r.sort!q{ a.sum < b.sum }.release;
}

void showMask(in uint mask) nothrow {
    for (size_t m = 0; (1U << m) <= mask; m++)
        if (mask & (1U << m))
            // Much faster than writeln.
            // The names are all zero-terminated.
            printf("%s ", em[m].data.ptr);
    if (mask)
        putchar('\n');
}

int printList(in int i, in int j, in int i1, in int j1,
              in Sum[] l, in Sum[] r) nothrow {
    int s = (i1 - i) * (j - j1);
    if (!l[i].sum)
        s--;

    static if (showAllSolutions)
        foreach (immutable x; i .. i1)
            foreach_reverse (immutable size_t y; j1 + 1 .. j + 1)
                showMask(l[x].mask | r[y].mask);
    return s;
}

void main() {
    immutable N = em.length;
    assert(N <= em[0].sizeof * 8, "Not enough bits in the mask");
    immutable size_t n1 = N / 2;
    immutable size_t n2 = N - n1;
    immutable size_t n1p = 1 << n1;
    immutable size_t n2p = 1 << n2;

    auto l = mkSums(em[], n1, 0);
    auto r = mkSums(em[n1 .. $], n2, n1);

    size_t sols = 0;
    int i = 0;
    int j = n2p - 1;
    while (true) {
        while (l[i].sum + r[j].sum) {
            while (i < n1p && l[i].sum + r[j].sum < 0)
                i++;
            while (j >= 0 && l[i].sum + r[j].sum > 0)
                j--;
            if (i >= n1p || j < 0)
                break;
        }
        if (i >= n1p || j < 0)
            break;

        int i1 = i + 1;
        while (i1 < n1p && l[i1].sum == l[i].sum)
            i1++;

        int j1 = j - 1;
        while (j1 >= 0 && r[j1].sum == r[j].sum)
            j1--;

        sols += printList(i, j, i1, j1, l, r);
        i = i1;
        j = j1;
    }

    writeln("Zero sums: ", sols);
}
