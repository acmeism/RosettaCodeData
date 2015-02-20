void main() {
    import std.stdio, std.string, std.range, std.algorithm;

    immutable text =
"---------- Ice and Fire ------------

fire, in end will world the say Some
ice. in say Some
desire of tasted I've what From
fire. favor who those with hold I

... elided paragraph last ...

Frost Robert -----------------------";

    writefln("%(%-(%s %)\n%)",
             text.splitLines.map!(r => r.split.retro));
}
