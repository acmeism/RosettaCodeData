import std.array;
import std.stdio;
import std.uni;

immutable string[char] codes;
shared static this() {
    codes = [
        'a': "AAAAA", 'b': "AAAAB", 'c': "AAABA", 'd': "AAABB", 'e': "AABAA",
        'f': "AABAB", 'g': "AABBA", 'h': "AABBB", 'i': "ABAAA", 'j': "ABAAB",
        'k': "ABABA", 'l': "ABABB", 'm': "ABBAA", 'n': "ABBAB", 'o': "ABBBA",
        'p': "ABBBB", 'q': "BAAAA", 'r': "BAAAB", 's': "BAABA", 't': "BAABB",
        'u': "BABAA", 'v': "BABAB", 'w': "BABBA", 'x': "BABBB", 'y': "BBAAA",
        'z': "BBAAB", ' ': "BBBAA", // use ' ' to denote any non-letter
    ];
}

string encode(string plainText, string message) {
    string pt = plainText.toLower;
    auto sb = appender!string;
    foreach (c; pt) {
        if ('a' <= c && c <= 'z') {
            sb ~= codes[c];
        } else {
            sb ~= codes[' '];
        }
    }
    string et = sb.data;
    string mg = message.toLower;
    sb = appender!string;
    int count = 0;
    foreach (c; mg) {
        if ('a' <= c && c <= 'z') {
            if (et[count] == 'A') {
                sb ~= c;
            } else {
                sb ~= cast(char)(c - 32);
            }
            count++;
            if (count == et.length) {
                break;
            }
        } else {
            sb ~= c;
        }
    }

    return sb.data;
}

string decode(string message) {
    auto sb = appender!string;
    foreach (c; message) {
        if ('a' <= c && c <= 'z') {
            sb ~= 'A';
        } else if ('A' <= c && c <= 'Z') {
            sb ~= 'B';
        }
    }
    string et = sb.data;
    sb = appender!string;
    for (int i=0; i<et.length; i+=5) {
        string quintet = et[i .. i+5];
        foreach (k,v; codes) {
            if (v == quintet) {
                sb ~= k;
                break;
            }
        }
    }
    return sb.data;
}

void main() {
    string plainText = "the quick brown fox jumps over the lazy dog";
    string message = "bacon's cipher is a method of steganography created by francis bacon. " ~
                    "this task is to implement a program for encryption and decryption of " ~
                    "plaintext using the simple alphabet of the baconian cipher or some " ~
                    "other kind of representation of this alphabet (make anything signify anything). " ~
                    "the baconian alphabet may optionally be extended to encode all lower " ~
                    "case characters individually and/or adding a few punctuation characters " ~
                    "such as the space.";
    string cipherText = encode(plainText, message);
    writeln("Cipher text ->");
    writeln(cipherText);
    writeln;

    string decodedText = decode(cipherText);
    writeln("Hidden text ->");
    writeln(decodedText);
}
