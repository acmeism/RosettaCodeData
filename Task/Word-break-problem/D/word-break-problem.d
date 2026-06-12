import std.algorithm;
import std.range;
import std.stdio;

void main() {
    string[] dict = ["a", "aa", "b", "ab", "aab"];
    process(dict, ["aab", "aa b"]);

    dict = ["abc", "a", "ac", "b", "c", "cb", "d"];
    process(dict, ["abcd", "abbc", "abcbcd", "acdbc", "abcdd"]);
}

void process(string[] dict, string[] testStrings) {
    foreach (testString; testStrings) {
        auto matches = wordBreak(testString, dict);
        writeln("String = ", testString, ", Dictionary = ", dict, ".  Solutions = ", matches.length);
        foreach (match; matches) {
            writeln("  Word Break = ", match);
        }
        writeln();
    }
}

string[][] wordBreak(string s, string[] dictionary) {
    string[][] matches;
    Node[] queue = [Node(s)];
    while (!queue.empty) {
        auto node = queue.front;
        queue.popFront;
        // Check if fully parsed
        if (node.val.length == 0) {
            matches ~= node.parsed;
        } else {
            foreach (word; dictionary) {
                // Check for match
                if (node.val.startsWith(word)) {
                    auto valNew = node.val[word.length .. node.val.length];
                    auto parsedNew = node.parsed.dup;
                    parsedNew ~= word;
                    queue ~= Node(valNew, parsedNew);
                }
            }
        }
    }
    return matches;
}

struct Node {
    string val;
    string[] parsed;

    this(string initial) {
        val = initial;
    }

    this(string s, string[] p) {
        val = s;
        parsed = p;
    }
}
