import std.stdio;
import std.uni; // standard package for normalization, composition/decomposition, etc..
import std.utf; // standard package for decoding/encoding, etc...

void main() {
    // normal identifiers are allowed
    int a;
    // unicode characters are allowed for identifers
    int δ;

    char c;  // 1 to 4 byte unicode character
    wchar w; // 2 or 4 byte unicode character
    dchar d; // 4 byte unicode character

    writeln("some text");     // strings by default are UTF8
    writeln("some text"c);    // optional suffix for UTF8
    writeln("こんにちは"c);      // unicode charcters are just fine (stored in the string type)
    writeln("Здравствуйте"w); // also avaiable are UTF16 string  (stored in the wstring type)
    writeln("שלום"d);         // and UTF32 strings (stored in the dstring type)

    // escape sequences like what is defined in C are also allowed inside of strings and characters.
}
