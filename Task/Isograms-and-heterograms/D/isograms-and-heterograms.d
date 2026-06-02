import std.stdio, std.file, std.string, std.range, std.algorithm, std.typecons;

bool isIsogram(string s) {
    return s.array.sort.group.assocArray.values.uniq.walkLength == 1;
}

ulong isogramLevel(string s) {
    return s.count(s[0]);
}

void main() {
    auto isograms = readText("unixdict.txt").splitLines.filter!isIsogram;

    writeln("n-isograms with n > 1:");
    isograms
        .filter!(s => isogramLevel(s) > 1).array
        .schwartzSort!(a => tuple(-a.isogramLevel, -a.length, a))
        .each!writeln;

    writeln;
    writeln("Heterograms with more than 10 letters:");
    isograms
        .filter!(s => isogramLevel(s) ==1 && s.length > 10).array
        .schwartzSort!(a => tuple(-a.length, a))
        .each!writeln;
}
