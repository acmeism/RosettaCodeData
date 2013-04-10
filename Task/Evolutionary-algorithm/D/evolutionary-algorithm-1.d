import std.stdio, std.random, std.algorithm, std.range, std.ascii;

void evolve(string target, double prob=0.05, int C=100) {
    auto chars = uppercase ~ " ";
    char rndCh() { return chars[uniform(0, $)]; }
    void mutate(char[] parent, char[] child) {
        foreach (i, ref c; child)
            c = uniform(0.0, 1.0) < prob ? rndCh() : parent[i];
    }
    int fitness(char[] subject, string target) {
        return count!q{ a[0] != a[1] }(zip(subject, target));
    }
    auto parent= map!(i => rndCh())(target).array();
    auto best = parent.dup;
    auto child = new char[target.length];
    int currDist = fitness(parent, target);
    for (int gen; currDist > 0; gen++) {
        foreach (_; 0 .. C) {
            mutate(parent, child);
            int dist = fitness(child, target);
            if (dist < currDist) {
                currDist = dist;
                best[] = child[];
            }
        }
        parent = best;
        writefln("Generation %2s, dist=%2s: %s", gen, currDist, best);
    }
}

void main() {
    evolve("METHINKS IT IS LIKE A WEASEL");
}
