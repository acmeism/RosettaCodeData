import std.stdio;

void collapsible(string s) {
    writeln("old: <<<", s, ">>>, length = ", s.length);

    write("new: <<<");
    char last = '\0';
    int len = 0;
    foreach (c; s) {
        if (c != last) {
            write(c);
            len++;
        }
        last = c;
    }
    writeln(">>>, length = ", len);

    writeln;
}

void main() {
    collapsible(``);
    collapsible(`"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln `);
    collapsible(`..1111111111111111111111111111111111111111111111111111111111111117777888`);
    collapsible(`I never give 'em hell, I just tell the truth, and they think it's hell. `);
    collapsible(`                                                    --- Harry S Truman  `);
}
