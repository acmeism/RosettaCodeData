import std.stdio, std.algorithm, std.string, std.array;

immutable T = ["79|0|1|2|3|4|5|6|7|8|9", "|H|O|L||M|E|S||R|T",
               "3|A|B|C|D|F|G|I|J|K|N", "7|P|Q|U|V|W|X|Y|Z|.|/"]
              .map!(r => r.split("|")).array;

enum straddle = (in string s) pure /*nothrow @safe*/ =>
    toUpper(s)
    .split("")
    .cartesianProduct(T)
    .filter!(cL => cL[1].canFind(cL[0]))
    .map!(cL => cL[1][0] ~ T[0][cL[1].countUntil(cL[0])])
    .join;

string unStraddle(string s) pure nothrow @safe {
    string result;
    for (; !s.empty; s.popFront) {
        immutable i = [T[2][0], T[3][0]].countUntil([s[0]]);
        if (i >= 0) {
            s.popFront;
            immutable n = T[2 + i][T[0].countUntil([s[0]])];
            if (n == "/") {
                s.popFront;
                result ~= s[0];
            } else result ~= n;
        } else
            result ~= T[1][T[0].countUntil([s[0]])];
    }
    return result;
}

void main() {
    immutable O = "One night-it was on the twentieth of March, 1888-I was returning";
    writeln("Encoded: ", O.straddle);
    writeln("Decoded: ", O.straddle.unStraddle);
}
