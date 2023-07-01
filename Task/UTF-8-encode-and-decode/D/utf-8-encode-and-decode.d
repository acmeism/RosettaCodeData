import std.conv;
import std.stdio;

immutable CHARS = ["A","ö","Ж","€","𝄞"];

void main() {
    writeln("Character   Code-Point   Code-Units");
    foreach (c; CHARS) {
        auto bytes = cast(ubyte[]) c; //The raw bytes of a character can be accessed by casting
        auto unicode = cast(uint) to!dstring(c)[0]; //Convert from a UTF8 string to a UTF32 string, and cast the first character to a number
        writefln("%s              %7X   [%(%X, %)]", c, unicode, bytes);
    }
}
