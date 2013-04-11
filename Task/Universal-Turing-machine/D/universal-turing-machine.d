import std.stdio, std.algorithm, std.string, std.conv, std.array,
       std.exception;

struct UTM(bool doShow=true) {
    alias Symbol = uint;
    alias State = char; // Typedef?
    enum Direction { right, left, stay }

    private TapeHead head;
    private const TuringMachine tm;

    static struct Rule {
        Symbol toWrite;
        Direction direction;
        State nextState;
    }

    static struct TuringMachine {
        Symbol[] symbols;
        Symbol blank;
        State initialState;
        State[] haltStates, runningStates;
        Rule[Symbol][State] rules;
        Symbol[] input;
    }

    static struct TapeHead {
        immutable Symbol blank;
        Symbol[] tape;
        size_t position;

        this(in ref TuringMachine t) pure /*nothrow*/ {
            this.blank = t.blank;
            this.tape = t.input.dup; // Not nothrow.
            if (this.tape.empty)
                this.tape = [this.blank];
            this.position = 0;
        }

        pure nothrow invariant() {
            assert(this.position < this.tape.length);
        }

        Symbol read() const pure nothrow {
            return this.tape[this.position];
        }

        void show() const {
            .write(this);
        }

        void write(in Symbol symbol) {
            static if (doShow)
                show();
            this.tape[this.position] = symbol;
        }

        void right() pure nothrow {
            this.position++;
            if (this.position == this.tape.length)
                this.tape ~= this.blank;
        }

        void left() pure nothrow {
            if (this.position == 0)
                this.tape = this.blank ~ this.tape;
            else
                this.position--;
        }

        void move(in Direction dir) {
            final switch (dir) {
                case Direction.left:  left();         break;
                case Direction.right: right();        break;
                case Direction.stay:  /*Do nothing.*/ break;
            }
        }

        string toString() const {
            return format("...%(%)...", this.tape)
                   ~ '\n'
                   ~ format("%" ~ text(this.position + 4) ~ "s", "^")
                   ~ '\n';
        }
    }

    void show() const {
        head.show();
    }

    this(const ref TuringMachine tm_) {
        immutable errMsg = "Invalid input.";
        enforce(!tm_.runningStates.empty, errMsg);
        enforce(!tm_.haltStates.empty, errMsg);
        enforce(!tm_.symbols.empty, errMsg);
        enforce(tm_.rules.length, errMsg);
        enforce(tm_.runningStates.canFind(tm_.initialState), errMsg);
        enforce(tm_.symbols.canFind(tm_.blank), errMsg);
        const allStates = tm_.runningStates ~ tm_.haltStates;
        foreach (const s; tm_.rules.keys.to!(dchar[])().sort())
            enforce(tm_.runningStates.canFind(s), errMsg);
        foreach (const aa; tm_.rules.byValue)
            foreach (/*const*/ s, const rule; aa) {
                enforce(tm_.symbols.canFind(s), errMsg);
                enforce(tm_.symbols.canFind(rule.toWrite), errMsg);
                enforce(allStates.canFind(rule.nextState), errMsg);
            }

        this.tm = tm_;
        this.head = TapeHead(this.tm);

        State state = this.tm.initialState;
        while (true) {
            if (tm.haltStates.canFind(state))
                break;
            if (!tm.runningStates.canFind(state))
                throw new Exception("Unknown state.");
            immutable symbol = this.head.read();
            immutable rule = this.tm.rules[state][symbol];
            this.head.write(rule.toWrite);
            this.head.move(rule.direction);
            state = rule.nextState;
        }
        static if (doShow)
            show();
    }
}

void main() {
    with (UTM!()) {
        alias R = Rule;
        writeln("Incrementer:");
        TuringMachine tm1;
        tm1.symbols = [0, 1];
        tm1.blank = 0;
        tm1.initialState = 'A';
        tm1.haltStates = ['H'];
        tm1.runningStates = ['A'];
        with (Direction)
            tm1.rules = ['A': [0: R(1, left,  'H'),
                               1: R(1, right, 'A')]];
        tm1.input = [1, 1, 1];
        UTM!()(tm1);

        // http://en.wikipedia.org/wiki/Busy_beaver
        writeln("\nBusy beaver machine (3-state, 2-symbol):");
        TuringMachine tm2;
        tm2.symbols = [0, 1];
        tm2.blank = 0;
        tm2.initialState = 'A';
        tm2.haltStates = ['H'];
        tm2.runningStates = ['A', 'B', 'C'];
        with (Direction)
            tm2.rules = ['A': [0: R(1, right, 'B'),
                               1: R(1, left,  'C')],
                         'B': [0: R(1, left,  'A'),
                               1: R(1, right, 'B')],
                         'C': [0: R(1, left,  'B'),
                               1: R(1, stay,  'H')]];
        UTM!()(tm2);
    }

    with (UTM!false) {
        writeln("\nSorting stress test (12212212121212):");
        alias R = Rule;
        TuringMachine tm3;
        tm3.symbols = [0, 1, 2, 3];
        tm3.blank = 0;
        tm3.initialState = 'A';
        tm3.haltStates = ['H'];
        tm3.runningStates = ['A', 'B', 'C', 'D', 'E'];
        with (Direction)
            tm3.rules = ['A': [1: R(1, right, 'A'),
                               2: R(3, right, 'B'),
                               0: R(0, left,  'E')],
                         'B': [1: R(1, right, 'B'),
                               2: R(2, right, 'B'),
                               0: R(0, left,  'C')],
                         'C': [1: R(2, left,  'D'),
                               2: R(2, left,  'C'),
                               3: R(2, left,  'E')],
                         'D': [1: R(1, left,  'D'),
                               2: R(2, left,  'D'),
                               3: R(1, right, 'A')],
                         'E': [1: R(1, left,  'E'),
                               0: R(0, right, 'H')]];
        tm3.input = [1, 2, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2];
        UTM!false(tm3).show();
    }
}
