import std.array, std.string, std.ascii, std.algorithm, std.range;

/**
Soundex is a phonetic algorithm for indexing names by
sound, as pronounced in English. See:
http://en.wikipedia.org/wiki/Soundex
*/
string soundex(in string name) pure /*nothrow*/
out(result) {
    assert(result.length == 4);
    assert(result[0] == '0' || result[0].isUpper);

    if (name.empty)
        assert(result == "0000");
    immutable charCount = name.filter!isAlpha.walkLength;
    assert((charCount == 0) == (result == "0000"));
} body {
    // Adapted from public domain Python code by Gregory Jorgensen:
    // http://code.activestate.com/recipes/52213/
    // digits holds the soundex values for the alphabet.
    static immutable digits = "01230120022455012623010202";
    string firstChar, result;

    // Translate alpha chars in name to soundex digits.
    foreach (immutable dchar c; name.toUpper) { // Not nothrow.
        if (c.isUpper) {
            if (firstChar.empty)
                firstChar ~= c; // Remember first letter.
            immutable char d = digits[c - 'A'];
            // Duplicate consecutive soundex digits are skipped.
            if (!result.length || d != result.back)
                result ~= d;
        }
    }

    // Return 0000 if the name is empty.
    if (!firstChar.length)
        return "0000";

    // Replace first digit with first alpha character.
    assert(!result.empty);
    result = firstChar ~ result[1 .. $];

    // Remove all 0s from the soundex code.
    result = result.replace("0", "");

    // Return soundex code padded to 4 zeros.
    return (result ~ "0000")[0 .. 4];
} unittest { // Tests of soundex().
    auto tests = [["",         "0000"], ["12346",     "0000"],
                  ["he",       "H000"], ["soundex",   "S532"],
                  ["example",  "E251"], ["ciondecks", "C532"],
                  ["ekzampul", "E251"], ["rÃ©sumÃ©",  "R250"],
                  ["Robert",   "R163"], ["Rupert",    "R163"],
                  ["Rubin",    "R150"], ["Ashcraft",  "A226"],
                  ["Ashcroft", "A226"]];
    foreach (const pair; tests)
        assert(pair[0].soundex == pair[1]);
}

void main() {}
