import std.stdio;

void squeezable(string s, char rune) {
    writeln("squeeze: '", rune, "'");
    writeln("old: <<<", s, ">>>, length = ", s.length);

    write("new: <<<");
    char last = '\0';
    int len = 0;
    foreach (c; s) {
        if (c != last || c != rune) {
            write(c);
            len++;
        }
        last = c;
    }
    writeln(">>>, length = ", len);

    writeln;
}

void main() {
    squeezable(``, ' ');
    squeezable(`"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln `, '-');
    squeezable(`..1111111111111111111111111111111111111111111111111111111111111117777888`, '7');
    squeezable(`I never give 'em hell, I just tell the truth, and they think it's hell. `, '.');

    string s = `                                                    --- Harry S Truman  `;
    squeezable(s, ' ');
    squeezable(s, '-');
    squeezable(s, 'r');
}
