import std.stdio, std.algorithm, std.string, std.range, std.typecons;

Tuple!(uint, string[]) findLongestChain(in string[] words)
pure nothrow {
    static struct Pair { string word; bool unused; }
    uint nSolutions;

    void search(Pair[][] sequences, in size_t minHead,
                in string currWord, string[] currentPath,
                size_t currentPathLen,
                ref string[] longestPath) nothrow {
        currentPath[currentPathLen] = currWord;
        currentPathLen++;

        if (currentPathLen == longestPath.length) {
            nSolutions++;
        }  else if (currentPathLen > longestPath.length) {
            nSolutions = 1;
            longestPath = currentPath[0 .. currentPathLen].dup;
        }

        // Recursive search.
        immutable size_t lastCharIndex = currWord[$ - 1] - minHead;
        if (lastCharIndex < sequences.length)
            foreach (ref pair; sequences[lastCharIndex])
                if (pair.unused) {
                    pair.unused = false;
                    search(sequences, minHead, pair.word, currentPath,
                           currentPathLen, longestPath);
                    pair.unused = true;
                }
    }

    if (words.empty)
        typeof(return)(0, null);
    immutable heads = words.map!q{ a[0] }.array;
    immutable size_t minHead = reduce!min(heads[0],
                                          heads[1.. $].representation);
    immutable size_t maxHead = reduce!max(heads[0],
                                          heads[1.. $].representation);

    auto sequences = new Pair[][](maxHead - minHead + 1, 0);
    foreach (const word; words)
        sequences[word[0] - minHead] ~= Pair(word, true);

    auto currentPath = new string[words.length];
    string[] longestPath;

    // Try each item as possible start.
    foreach (seq; sequences)
        foreach (ref pair; seq) {
            pair.unused = false;
            search(sequences, minHead, pair.word,
                   currentPath, 0, longestPath);
            pair.unused = true;
       }

    return typeof(return)(nSolutions, longestPath);
}


void main() {
    auto pokemon = "audino bagon baltoy banette bidoof braviary
bronzor carracosta charmeleon cresselia croagunk darmanitan deino
emboar emolga exeggcute gabite girafarig gulpin haxorus heatmor
heatran ivysaur jellicent jumpluff kangaskhan kricketune landorus
ledyba loudred lumineon lunatone machamp magnezone mamoswine nosepass
petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2
porygonz registeel relicanth remoraid rufflet sableye scolipede
scrafty seaking sealeo silcoon simisear snivy snorlax spoink starly
tirtouga trapinch treecko tyrogue vigoroth vulpix wailord wartortle
whismur wingull yamask".toLower.split;

    // Remove duplicates.
    pokemon.length -= pokemon.sort().uniq.copy(pokemon).length;

    const sol = pokemon.findLongestChain;
    writeln("Maximum path length: ", sol[1].length);
    writeln("Paths of that length: ", sol[0]);
    writeln("Example path of that length:");
    writefln("%(  %-(%s %)\n%)", sol[1].chunks(7));
}
