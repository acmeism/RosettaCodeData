import std.stdio;
import std.uni;

string redact(string source, string word, bool partial = false, bool insensitive = false, bool overkill = false) {
    bool different(char s, char w) {
        if (insensitive) {
            return s.toUpper != w.toUpper;
        } else {
            return s != w;
        }
    }

    bool isWordChar(char c) {
        return c == '-' || c.isAlpha;
    }

    auto temp = source.dup;

    foreach (i; 0 .. temp.length - word.length + 1) {
        bool match = true;
        foreach (j; 0 .. word.length) {
            if (different(temp[i + j], word[j])) {
                match = false;
                break;
            }
        }
        if (match) {
            auto beg = i;
            auto end = i + word.length;

            if (!partial) {
                if (beg > 0 && isWordChar(temp[beg - 1])) {
                    // writeln("b boundary ", temp[beg - 1]);
                    continue;
                }
                if (end < temp.length && isWordChar(temp[end])) {
                    // writeln("e boundary ", temp[end]);
                    continue;
                }
            }
            if (overkill) {
                while (beg > 0 && isWordChar(temp[beg - 1])) {
                    beg--;
                }
                while (end < temp.length - 1 && isWordChar(temp[end])) {
                    end++;
                }
            }

            temp[beg .. end] = 'X';
        }
    }

    return temp.idup;
}

void example(string source, string word) {
    writeln("Redact ", word);
    writeln("[w|s|n] ", redact(source, word, false, false, false));
    writeln("[w|i|n] ", redact(source, word, false, true, false));
    writeln("[p|s|n] ", redact(source, word, true, false, false));
    writeln("[p|i|n] ", redact(source, word, true, true, false));
    writeln("[p|s|o] ", redact(source, word, true, false, true));
    writeln("[p|i|o] ", redact(source, word, true, true, true));
    writeln;
}

void main(string[] args) {
    string text = `Tom? Toms bottom tomato is in his stomach while playing the "Tom-tom" brand tom-toms. That's so tom`;
    example(text, "Tom");
    example(text, "tom");
}
