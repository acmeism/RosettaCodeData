import std.stdio, std.math, std.algorithm, std.traits, permutations2;

void main() {
    enum Names { Baker, Cooper, Fletcher, Miller, Smith }

    immutable(bool function(in Names[]) pure nothrow)[] predicates = [
        s => s[Names.Baker] != s.length - 1,
        s => s[Names.Cooper] != 0,
        s => s[Names.Fletcher] != 0 && s[Names.Fletcher] != s.length-1,
        s => s[Names.Miller] > s[Names.Cooper],
        s => abs(s[Names.Smith] - s[Names.Fletcher]) != 1,
        s => abs(s[Names.Cooper] - s[Names.Fletcher]) != 1];

    permutations([EnumMembers!Names])
    .filter!(solution => predicates.all!(pred => pred(solution)))
    .writeln;
}
