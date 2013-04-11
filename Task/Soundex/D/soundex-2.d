import std.string: toUpper, replace;
import std.ascii: isUpper;

/*****************************
Soundex is a phonetic algorithm for indexing names by
sound, as pronounced in English. See:
http://en.wikipedia.org/wiki/Soundex
*/
/*pure nothrow*/ string soundex(in string name)
// Adapted from public domain Python code by Gregory Jorgensen:
// http://code.activestate.com/recipes/52213/
out(result) { // postcondition
    assert(result.length == 4);
    assert(result[0] == '0' || isUpper(result[0]));

    if (name.length == 0)
        assert(result == "0000");

    // this is too much fiddly
    int charCount = 0;
    foreach (dchar c; name)
        if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z'))
            charCount++;
    assert((charCount == 0) == (result == "0000"));
} body {
    // digits holds the soundex values for the alphabet
    static immutable digits = "01230120022455012623010202";
    string firstChar, result;

    // translate alpha chars in name to soundex digits
    foreach (dchar c; name.toUpper()) {
        if (c >= 'A' && c <= 'Z') {
            if (!firstChar.length)
                firstChar ~= c; // remember first letter
            immutable char d = digits[c - 'A'];
            // duplicate consecutive soundex digits are skipped
            if (!result.length || d != result[$ - 1])
                result ~= d;
        }
    }

    // return 0000 if the name is empty
    if (!firstChar.length)
        return "0000";

    // replace first digit with first alpha character
    assert(result.length > 0);
    result = firstChar ~ result[1 .. $];

    // remove all 0s from the soundex code
    result = result.replace("0", ""); // not pure

    // return soundex code padded to 4 zeros
    return (result ~ "0000")[0 .. 4];
} unittest { // tests of soundex()
    auto tests = [["",         "0000"], ["12346",     "0000"],
                  ["he",       "H000"], ["soundex",   "S532"],
                  ["example",  "E251"], ["ciondecks", "C532"],
                  ["ekzampul", "E251"], ["rÃ©sumÃ©",  "R250"],
                  ["Robert",   "R163"], ["Rupert",    "R163"],
                  ["Rubin",    "R150"], ["Ashcraft",  "A226"],
                  ["Ashcroft", "A226"]];
    foreach (pair; tests)
        assert(soundex(pair[0]) == pair[1]);
}

void main() {}
