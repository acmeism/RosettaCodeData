import std.stdio, std.conv, std.algorithm;

string lookAndSay(string input) {
    string result;
    foreach (digit, count; input.group())
        result ~= text(count, digit);
    return result;
}

void main() {
    auto terms = ["1"];
    foreach (_; 0 .. 7)
        terms ~= terms[$ - 1].lookAndSay();
    writeln(terms);
}
