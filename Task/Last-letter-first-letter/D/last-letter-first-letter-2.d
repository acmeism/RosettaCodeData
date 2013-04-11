import std.stdio, std.algorithm, std.string,
       std.range, std.typecons;

alias Tuple!(string,"word", bool,"unused") Pair;
int nSolutions;

void search(Pair[][] sequences, in size_t minHead,
            in string currWord, string[] currentPath,
            size_t currentPathLen,
            ref string[] longestPath) {
    currentPath[currentPathLen] = currWord;
    currentPathLen++;

    if (currentPathLen == longestPath.length) {
        nSolutions++;
    }  else if (currentPathLen > longestPath.length) {
        nSolutions = 1;
        longestPath = currentPath[0 .. currentPathLen].dup;
    }

    // recursive search
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

string[] findLongestChain(in string[] words) {
    auto heads = map!q{ a[0] }(words);
    immutable size_t minHead = reduce!min(heads);
    immutable size_t maxHead = reduce!max(heads);
    auto sequences = new Pair[][](maxHead - minHead + 1, 0);
    foreach (word; words) {
        const p = Pair(word, true); //*
        sequences[word[0] - minHead] ~= p;
    }

    auto currentPath = new string[words.length];
    string[] longestPath;

    // try each item as possible start
    foreach (seq; sequences)
        foreach (ref pair; seq) {
            pair.unused = false;
            search(sequences, minHead, pair.word,
                   currentPath, 0, longestPath);
            pair.unused = true;
       }

    return longestPath;
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
whismur wingull yamask".toLower().split();

    // remove duplicates
    pokemon.length -= pokemon.sort().uniq().copy(pokemon).length;

    const sol = findLongestChain(pokemon);
    writeln("Maximum path length: ", sol.length);
    writeln("Paths of that length: ", nSolutions);
    writeln("Example path of that length:");
    foreach (ch; std.range.chunks(sol, 7))
        writefln("  %-(%s %)", ch);
}
