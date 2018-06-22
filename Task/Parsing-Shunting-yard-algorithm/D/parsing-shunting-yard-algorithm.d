import std.container;
import std.stdio;

void main() {
    string infix = "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3";
    writeln("infix:   ", infix);
    writeln("postfix: ", infixToPostfix(infix));
}

string infixToPostfix(string infix) {
    import std.array;

    /* To find out the precedence, we take the index of the
       token in the ops string and divide by 2 (rounding down).
       This will give us: 0, 0, 1, 1, 2 */
    immutable ops = ["+", "-", "/", "*", "^"];

    auto sb = appender!string;
    SList!int stack;

    // split the input on whitespace
    foreach (token; infix.split) {
        if (token.empty) {
            continue;
        }

        int idx = ops.indexOf(token);

        // check for operator
        if (idx != -1) {
            while (!stack.empty) {
                int prec2 = stack.peek / 2;
                int prec1 = idx / 2;
                if (prec2 > prec1 || (prec2 == prec1 && token != "^")) {
                    sb.put(ops[stack.pop]);
                    sb.put(' ');
                } else {
                    break;
                }
            }
            stack.push(idx);
        } else if (token == "(") {
            stack.push(-2); // -2 stands for '('
        } else if (token == ")") {
            // until '(' on stack, pop operators.
            while (stack.peek != -2) {
                sb.put(ops[stack.pop]);
                sb.put(' ');
            }
            stack.pop();
        } else {
            sb.put(token);
            sb.put(' ');
        }
    }

    while (!stack.empty) {
        sb.put(ops[stack.pop]);
        sb.put(' ');
    }

    return sb.data;
}

// Find the first index of the specified value, or -1 if not found.
int indexOf(T)(const T[] a, const T v) {
    foreach(i,e; a) {
        if (e == v) {
            return i;
        }
    }
    return -1;
}

// Convienience for adding a new element
void push(T)(ref SList!T s, T v) {
    s.insertFront(v);
}

// Convienience for accessing the top element
auto peek(T)(SList!T s) {
    return s.front;
}

// Convienience for removing and returning the top element
auto pop(T)(ref SList!T s) {
    auto v = s.front;
    s.removeFront;
    return v;
}
