import std.conv;
import std.range;
import std.stdio;
import std.string;

enum State {
    READY,
    WAITING,
    EXIT,
    DISPENSE,
    REFUNDING,
}

void fsm() {
    writeln("PLease enter your option when prompted");
    writeln("(any characters after the first will be ignored)");
    auto state = State.READY;
    string trans;

    while (true) {
        final switch (state) {
            case State.READY:
                do {
                    write("(D)ispense or (Q)uit : ");
                    trans = readln().toLower.take(1).to!string;
                } while (trans != "d" && trans != "q");
                if (trans == "d") {
                    state = State.WAITING;
                } else {
                    state = State.EXIT;
                }
                break;
            case State.WAITING:
                writeln("OK, put your money in the slot");
                do {
                    write("(S)elect product or choose a (R)efund : ");
                    trans = readln().toLower.take(1).to!string;
                } while (trans != "s" && trans != "r");
                if (trans == "s") {
                    state = State.DISPENSE;
                } else {
                    state = State.REFUNDING;
                }
                break;
            case State.DISPENSE:
                do {
                    write("(R)emove product : ");
                    trans = readln().toLower.take(1).to!string;
                } while (trans != "r");
                state = State.READY;
                break;
            case State.REFUNDING:
                writeln("OK, refunding your money");
                state = State.READY;
                break;
            case State.EXIT:
                writeln("OK, quitting");
                return;
        }
    }
}

void main() {
    fsm();
}
