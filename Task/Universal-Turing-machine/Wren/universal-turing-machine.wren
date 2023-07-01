import "/dynamic" for Enum, Tuple, Struct
import "/fmt" for Fmt

var Dir = Enum.create("Dir", ["LEFT", "RIGHT", "STAY"])

var Rule = Tuple.create("Rule", ["state1", "symbol1", "symbol2", "dir", "state2"])

var Tape = Struct.create("Tape", ["symbol", "left", "right"])

class Turing {
    construct new(states, finalStates, symbols, blank, state, tapeInput, rules) {
        _states = states
        _finalStates = finalStates
        _symbols = symbols
        _blank = blank
        _state = state
        _tape = null
        _transitions = List.filled(_states.count, null)
        for (i in 0..._states.count) _transitions[i] = List.filled(_symbols.count, null)
        for (i in 0...tapeInput.count) {
            move_(Dir.RIGHT)
            _tape.symbol = tapeInput[i]
        }
        if (tapeInput.count == 0) move_(Dir.RIGHT)
        while (_tape.left) _tape = _tape.left
        for (i in 0...rules.count) {
            var rule = rules[i]
            _transitions[stateIndex_(rule.state1)][symbolIndex_(rule.symbol1)] = rule
        }
    }

    stateIndex_(state) {
        var i = _states.indexOf(state)
        return (i >= 0) ? i : 0
    }

    symbolIndex_(symbol) {
        var i = _symbols.indexOf(symbol)
        return (i >= 0) ? i : 0
    }

    move_(dir) {
        var orig = _tape
        if (dir == Dir.RIGHT) {
            if (orig && orig.right) {
                _tape = orig.right
            } else {
                _tape = Tape.new(_blank, null, null)
                if (orig) {
                    _tape.left = orig
                    orig.right = _tape
                }
            }
        } else if (dir == Dir.LEFT) {
            if (orig && orig.left) {
                _tape = orig.left
            } else {
                _tape = Tape.new(_blank, null, null)
                if (orig) {
                    _tape.right = orig
                    orig.left = _tape
                }
            }
        } else if (dir == Dir.STAY) {}
    }

    printState() {
        Fmt.write("$-10s ", _state)
        var t = _tape
        while (t.left) t = t.left
        while (t) {
            if (t == _tape) {
                System.write("[%(t.symbol)]")
            } else {
                System.write(" %(t.symbol) ")
            }
            t = t.right
        }
        System.print()
    }

    run(maxLines) {
        var lines = 0
        while (true) {
            printState()
            for (finalState in _finalStates) {
                if (finalState == _state) return
            }
            lines = lines + 1
            if (lines == maxLines) {
                System.print("(Only the first %(maxLines) lines displayed)")
                return
            }
            var rule = _transitions[stateIndex_(_state)][symbolIndex_(_tape.symbol)]
            _tape.symbol = rule.symbol2
            move_(rule.dir)
            _state = rule.state2
        }
    }
}

System.print("Simple incrementer")
Turing.new(
    ["q0", "qf"],    // states
    ["qf"],          // finalStates
    ["B", "1"],      // symbols
    "B",             // blank
    "q0",            // state
    ["1", "1", "1"], // tapeInput
    [                // rules
        Rule.new("q0", "1", "1", Dir.RIGHT, "q0"),
        Rule.new("q0", "B", "1", Dir.STAY,  "qf")
    ]
).run(20)

System.print("\nThree-state busy beaver")
Turing.new(
    ["a", "b", "c", "halt"], // states
    ["halt"],                // finalStates
    ["0", "1"],              // symbols
    "0",                     // blank
    "a",                     // state
    [],                      // tapeInput
    [                        // rules
        Rule.new("a", "0", "1", Dir.RIGHT, "b"),
        Rule.new("a", "1", "1", Dir.LEFT,  "c"),
        Rule.new("b", "0", "1", Dir.LEFT,  "a"),
        Rule.new("b", "1", "1", Dir.RIGHT, "b"),
        Rule.new("c", "0", "1", Dir.LEFT,  "b"),
        Rule.new("c", "1", "1", Dir.STAY,  "halt")
    ]
).run(20)

System.print("\nFive-state two-symbol probable busy beaver")
Turing.new(
    ["A", "B", "C", "D", "E", "H"], // states
    ["H"],                          // finalStates
    ["0", "1"],                     // symbols
    "0",                            // blank
    "A",                            // state
    [],                             // tapeInput
    [                               // rules
        Rule.new("A", "0", "1", Dir.RIGHT, "B"),
        Rule.new("A", "1", "1", Dir.LEFT,  "C"),
        Rule.new("B", "0", "1", Dir.RIGHT, "C"),
        Rule.new("B", "1", "1", Dir.RIGHT, "B"),
        Rule.new("C", "0", "1", Dir.RIGHT, "D"),
        Rule.new("C", "1", "0", Dir.LEFT,  "E"),
        Rule.new("D", "0", "1", Dir.LEFT,  "A"),
        Rule.new("D", "1", "1", Dir.LEFT,  "D"),
        Rule.new("E", "0", "1", Dir.STAY,  "H"),
        Rule.new("E", "1", "0", Dir.LEFT,  "A")
    ]
).run(20)
