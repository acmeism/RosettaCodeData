import std.stdio, std.algorithm, std.string, std.conv, std.array,
       std.exception, std.traits, std.math, std.range;

struct UTM(State, Symbol, bool doShow=true)
if (is(State == enum) && is(Symbol == enum)) {
    static assert(is(typeof({ size_t x = State.init; })),
                  "State must to be usable as array index.");
    static assert([EnumMembers!State].equal(EnumMembers!State.length.iota),
                  "State must be a plain enum.");
    static assert(is(typeof({ size_t x = Symbol.init; })),
                  "Symbol must to be usable as array index.");
    static assert([EnumMembers!Symbol].equal(EnumMembers!Symbol.length.iota),
                  "Symbol must be a plain enum.");

    enum Direction { right, left, stay }

    private const TuringMachine tm;
    private TapeHead head;
    alias SymbolMap = string[EnumMembers!Symbol.length];

    // The first index of this 'rules' matrix is a subtype of State
    // because it can't contain H, but currently D can't enforce this,
    // statically unlike Ada language.
    Rule[EnumMembers!Symbol.length][EnumMembers!State.length - 1] mRules;

    static struct Rule {
        Symbol toWrite;
        Direction direction;
        State nextState;

        this(in Symbol toWrite_, in Direction direction_, in State nextState_)
        pure nothrow @safe @nogc {
            this.toWrite = toWrite_;
            this.direction = direction_;
            this.nextState = nextState_;
        }
    }

    // This is kept separated from the rest so it can be inialized
    // one field at a time in the main function, yet it will become
    // const.
    static struct TuringMachine {
        Symbol blank;
        State initialState;
        Rule[Symbol][State] rules;
        Symbol[] input;
        SymbolMap symbolMap;
    }

    static struct TapeHead {
        immutable Symbol blank;
        Symbol[] tapeLeft, tapeRight;
        int position;
        const SymbolMap sMap;
        size_t nSteps;

        this(in ref TuringMachine t) pure nothrow @safe {
            this.blank = EnumMembers!Symbol[0];
            //tapeRight = t.input.empty ? [this.blank] : t.input.dup;
            if (t.input.empty)
                this.tapeRight = [this.blank];
            else
                this.tapeRight = t.input.dup;
            this.position = 0;
            this.sMap = t.symbolMap;
        }

        pure nothrow @safe @nogc invariant {
            assert(this.tapeRight.length > 0);
            if (this.position >= 0)
                assert(this.position < this.tapeRight.length);
            else
                assert(this.position.abs <= this.tapeLeft.length);
        }

        Symbol readSymb() const pure nothrow @safe @nogc {
            if (this.position >= 0)
                return this.tapeRight[this.position];
            else
                return this.tapeLeft[this.position.abs - 1];
        }

        void showSymb() const @safe {
            this.write;
        }

        void writeSymb(in Symbol symbol) @safe {
            static if (doShow)
                showSymb;
            if (this.position >= 0)
                this.tapeRight[this.position] = symbol;
            else
                this.tapeLeft[this.position.abs - 1] = symbol;
        }

        void goRight() pure nothrow @safe {
            this.position++;
            if (position > 0 && position == tapeRight.length)
                tapeRight ~= blank;
        }

        void goLeft() pure nothrow @safe {
            this.position--;
            if (position < 0 && (position.abs - 1) == tapeLeft.length)
                tapeLeft ~= blank;
        }

        void move(in Direction dir) pure nothrow @safe {
            nSteps++;
            final switch (dir) with (Direction) {
                case left:  goLeft;        break;
                case right: goRight;       break;
                case stay:  /*Do nothing*/ break;
            }
        }

        string toString() const @safe {
            immutable pos = tapeLeft.length.signed + this.position + 4;
            return format("...%-(%)...", tapeLeft.retro.chain(tapeRight)
                                         .map!(s => sMap[s])) ~
                   '\n' ~
                   format("%" ~ pos.text ~ "s", "^") ~
                   '\n';
        }
    }

    void show() const @safe {
        head.showSymb;
    }

    this(in ref TuringMachine tm_) @safe {
        static assert(__traits(compiles, State.H), "State needs a 'H' (Halt).");
        immutable errMsg = "Invalid input.";
        auto runningStates = remove!(s => s == State.H)([EnumMembers!State]);
        enforce(!runningStates.empty, errMsg);
        enforce(tm_.rules.length == EnumMembers!State.length - 1, errMsg);
        enforce(State.H !in tm_.rules, errMsg);
        enforce(runningStates.canFind(tm_.initialState), errMsg);

        // Create a matrix to reduce running time.
        foreach (immutable State st, const rset; tm_.rules)
            foreach (immutable Symbol sy, immutable rule; rset)
                mRules[st][sy] = rule;

        this.tm = tm_;
        head = TapeHead(this.tm);

        State state = tm.initialState;
        while (state != State.H) {
            immutable next = mRules[state][head.readSymb];
            head.writeSymb(next.toWrite);
            head.move(next.direction);
            state = next.nextState;
        }
        static if (doShow)
            show;
        writeln("Performed ", head.nSteps, " steps.");
    }
}

void main() @safe {
    "Incrementer:".writeln;
    enum States1 : ubyte { A, H }
    enum Symbols1 : ubyte { s0, s1 }
    alias M1 = UTM!(States1, Symbols1);
    M1.TuringMachine tm1;
    with (tm1) with (States1) with (Symbols1) with (M1.Direction) {
        alias R = M1.Rule;
        initialState = A;
        rules = [A: [s0: R(s1, stay,  H), s1: R(s1, right, A)]];
        input = [s1, s1, s1];
        symbolMap = ["0", "1"];
    }
    M1(tm1);

    // http://en.wikipedia.org/wiki/Busy_beaver
    "\nBusy Beaver machine (3-state, 2-symbol):".writeln;
    enum States2 : ubyte { A, B, C, H }
    alias Symbols2 = Symbols1;
    alias M2 = UTM!(States2, Symbols2);
    M2.TuringMachine tm2;
    with (tm2) with (States2) with (Symbols2) with (M2.Direction) {
        alias R = M2.Rule;
        initialState = A;
        rules = [A: [s0: R(s1, right, B), s1: R(s1, left,  C)],
                 B: [s0: R(s1, left,  A), s1: R(s1, right, B)],
                 C: [s0: R(s1, left,  B), s1: R(s1, stay,  H)]];
        symbolMap = ["0", "1"];
    }
    M2(tm2);

    "\nSorting stress test (12212212121212):".writeln;
    enum States3 : ubyte { A, B, C, D, E, H }
    enum Symbols3 : ubyte { s0, s1, s2, s3 }
    alias M3 = UTM!(States3, Symbols3, false);
    M3.TuringMachine tm3;
    with (tm3) with (States3) with (Symbols3) with (M3.Direction) {
        alias R = M3.Rule;
        initialState = A;
        rules = [A: [s1: R(s1, right, A),
                     s2: R(s3, right, B),
                     s0: R(s0, left,  E)],
                 B: [s1: R(s1, right, B),
                     s2: R(s2, right, B),
                     s0: R(s0, left,  C)],
                 C: [s1: R(s2, left,  D),
                     s2: R(s2, left,  C),
                     s3: R(s2, left,  E)],
                 D: [s1: R(s1, left,  D),
                     s2: R(s2, left,  D),
                     s3: R(s1, right, A)],
                 E: [s1: R(s1, left,  E),
                     s0: R(s0, stay,  H)]];
        input = [s1, s2, s2, s1, s2, s2, s1,
                 s2, s1, s2, s1, s2, s1, s2];
        symbolMap = ["0", "1", "2", "3"];
    }
    M3(tm3).show;

    "\nPossible best Busy Beaver machine (5-state, 2-symbol):".writeln;
    alias States4 = States3;
    alias Symbols4 = Symbols1;
    alias M4 = UTM!(States4, Symbols4, false);
    M4.TuringMachine tm4;
    with (tm4) with (States4) with (Symbols4) with (M4.Direction) {
        alias R = M4.Rule;
        initialState = A;
        rules = [A: [s0: R(s1, right, B), s1: R(s1, left,  C)],
                 B: [s0: R(s1, right, C), s1: R(s1, right, B)],
                 C: [s0: R(s1, right, D), s1: R(s0, left,  E)],
                 D: [s0: R(s1, left,  A), s1: R(s1, left,  D)],
                 E: [s0: R(s1, stay,  H), s1: R(s0, left,  A)]];
        symbolMap = ["0", "1"];
    }
    M4(tm4);
}
