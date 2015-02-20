void main() {
    import std.stdio, std.string, std.algorithm, std.range, std.typetuple;

    immutable data =
"Given$a$txt$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column."
    .split.map!(r => r.chomp("$").split("$")).array;

    size_t[size_t] maxWidths;
    foreach (const line; data)
        foreach (immutable i, const word; line)
            maxWidths[i] = max(maxWidths.get(i, 0), word.length);

    foreach (immutable just; TypeTuple!(leftJustify, center, rightJustify))
        foreach (immutable line; data)
            writefln("%-(%s %)", line.length.iota
                     .map!(i => just(line[i], maxWidths[i], ' ')));
}
