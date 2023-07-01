import std.stdio: writeln;
import std.string: soundex;

void main() {
    assert(soundex("soundex") == "S532");
    assert(soundex("example") == "E251");
    assert(soundex("ciondecks") == "C532");
    assert(soundex("ekzampul") == "E251");
    assert(soundex("Robert") == "R163");
    assert(soundex("Rupert") == "R163");
    assert(soundex("Rubin") == "R150");
    assert(soundex("Ashcraft") == "A261");
    assert(soundex("Ashcroft") == "A261");
    assert(soundex("Tymczak") == "T522");
}
