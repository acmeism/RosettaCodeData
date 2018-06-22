import std.file;
import std.stdio;

int main(string[] args) {
    if (args.length < 2) {
        stderr.writeln(args[0], " filename");
        return 1;
    }

    int cei, cie, ie, ei;
    auto file = File(args[1]);
    foreach(line; file.byLine) {
        auto res = eval(cast(string) line);
        cei += res.cei;
        cie += res.cie;
        ei += res.ei;
        ie += res.ie;
    }

    writeln("CEI: ", cei, "; CIE: ", cie);
    writeln("EI: ", ei, "; IE: ", ie);

    writeln("'I before E when not preceded by C' is ", verdict(ie, ei));
    writeln("'E before I when preceded by C' is ", verdict(cei, cie));

    return 0;
}

string verdict(int a, int b) {
    import std.format;
    if (a > 2*b) {
        return format("plausible with evidence %f", cast(double)a/b);
    }
    return format("not plausible with evidence %f", cast(double)a/b);
}

struct Evidence {
    int cei;
    int cie;
    int ei;
    int ie;
}

Evidence eval(string word) {
    enum State {
        START,
        C,
        E,
        I,
        CE,
        CI,
    }

    State state;
    Evidence cnt;
    for(int i=0; i<word.length; ++i) {
        char c = word[i];
        switch(state) {
            case State.START:
                if (c == 'c') {
                    state = State.C;
                }
                if (c == 'e') {
                    state = State.E;
                }
                if (c == 'i') {
                    state = State.I;
                }
                break;
            case State.C:
                if (c == 'e') {
                    state = State.CE;
                } else if (c == 'i') {
                    state = State.CI;
                } else if (c != 'c') {
                    state = State.START;
                }
                break;
            case State.E:
                if (c == 'c') {
                    state = State.C;
                } else if (c == 'i') {
                    cnt.ei++;
                    state = State.I;
                } else if (c != 'e') {
                    state = State.START;
                }
                break;
            case State.I:
                if (c == 'c') {
                    state = State.C;
                } else if (c == 'e') {
                    cnt.ie++;
                    state = State.E;
                } else if (c != 'i') {
                    state = State.START;
                }
                break;
            case State.CE:
                if (c == 'i') {
                    cnt.cei++;
                    state = State.I;
                }
                if (c == 'c') {
                    state = State.C;
                }
                state = State.START;
                break;
            case State.CI:
                if (c == 'e') {
                    cnt.cie++;
                    state = State.E;
                }
                if (c == 'c') {
                    state = State.C;
                }
                state = State.START;
                break;
            default:
                assert(0);
        }
    }
    return cnt;
}
