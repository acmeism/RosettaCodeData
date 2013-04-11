import std.stdio: writeln;
import std.string: format;

void main() {
    auto original = "Mary had a %s lamb.";
    auto extra = "little";
    auto modified = format(original, extra);
    writeln(modified);
}
