import std.stdio, std.string, std.array, std.algorithm, std.typecons;

struct Var {
    const char name;
    bool val;
}
const string expr;
Var[] vars;

bool pop(ref bool[] arr) pure nothrow {
    const last = arr.back;
    arr.popBack;
    return last;
}

enum isOperator = (in char c) pure => "&|!^".canFind(c);

enum varsCountUntil = (in char c) nothrow =>
    .vars.map!(v => v.name).countUntil(c).Nullable!(int, -1);

bool evalExp() {
    bool[] stack;

    foreach (immutable e; .expr) {
        if (e == 'T')
            stack ~= true;
        else if (e == 'F')
            stack ~= false;
        else if (!e.varsCountUntil.isNull)
            stack ~= .vars[e.varsCountUntil.get].val;
        else switch (e) {
            case '&':
                stack ~= stack.pop & stack.pop;
                break;
            case '|':
                stack ~= stack.pop | stack.pop;
                break;
            case '!':
                stack ~= !stack.pop;
                break;
            case '^':
                stack ~= stack.pop ^ stack.pop;
                break;
            default:
                throw new Exception("Non-conformant character '" ~
                                    e ~ "' in expression.");
        }
    }

    assert(stack.length == 1);
    return stack.back;
}

void setVariables(in size_t pos)
in {
    assert(pos <= .vars.length);
} body {
    if (pos == .vars.length)
        return writefln("%-(%s %) %s",
                        .vars.map!(v => v.val ? "T" : "F"),
                        evalExp ? "T" : "F");

    .vars[pos].val = false;
    setVariables(pos + 1);
    .vars[pos].val = true;
    setVariables(pos + 1);
}

static this() {
"Accepts single-character variables (except for 'T' and 'F',
which specify explicit true or false values), postfix, with
&|!^ for and, or, not, xor, respectively; optionally
seperated by whitespace.".writeln;

    "Boolean expression: ".write;
    .expr = readln.split.join;
}

void main() {
    foreach (immutable e; expr)
        if (!e.isOperator && !"TF".canFind(e) &&
            e.varsCountUntil.isNull)
            .vars ~= Var(e);
    if (.vars.empty)
        return;

    writefln("%-(%s %) %s", .vars.map!(v => v.name), .expr);
    setVariables(0);
}
