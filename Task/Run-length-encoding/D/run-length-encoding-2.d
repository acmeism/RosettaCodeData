import std.stdio, std.array, std.conv;

// Similar to the 'look and say' function.
string encode(in string input) {
    if (input.empty) return input;
    char last = input[$ - 1];
    string output;
    int count;

    foreach_reverse (c; input) {
        if (c == last) {
            count++;
        } else {
            output = text(count) ~ last ~ output;
            count = 1;
            last = c;
        }
    }

    return text(count) ~ last ~ output;
}

string decode(in string input) {
    string i, result;

    foreach (c; input)
        switch (c) {
            case '0': .. case '9':
                i ~= c;
                break;
            case 'A': .. case 'Z':
                if (i.empty)
                    throw new Exception("Can not repeat a letter " ~
                        "without a number of repetitions");
                result ~= replicate([c], to!int(i));
                i.length = 0;
                break;
            default:
                throw new Exception("'" ~ c ~
                                    "' is not alphanumeric");
        }

    return result;
}

void main() {
    immutable txt = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWW" ~
                    "WWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW";
    writeln("Input: ", txt);
    immutable encoded = encode(txt);
    writeln("Encoded: ", encoded);
    assert(txt == decode(encoded));
}
