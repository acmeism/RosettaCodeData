import std.stdio, std.datetime, std.string, std.exception, std.conv;

void printCalendar(in int year, in int cols) {
    enforce(1 <= cols && cols <= 12);

    immutable rows = 12 / cols + (12 % cols != 0);
    auto date = Date(year, 1, 1);
    auto offs = cast(int)date.dayOfWeek();
    const monthNames = "January February March April May June "
    "July August September October November December".split(" ");

    string[8][12] mons;
    foreach (m; 0 .. 12) {
        mons[m][0] = monthNames[m].center(21);
        mons[m][1] = " Su Mo Tu We Th Fr Sa";
        immutable dim = date.daysInMonth();
        foreach (d; 1 .. 43) {
            immutable day = d > offs && d <= offs + dim;
            immutable str = day ? format(" %2s", d-offs) : "   ";
            mons[m][2 + (d - 1) / 7] ~= str;
        }
        offs = (offs + dim) % 7;
        date.add!"months"(1);
    }

    writeln("[Snoopy Picture]".center(cols * 24 + 4));
    writeln(text(year).center(cols * 24 + 4), "\n");
    foreach (r; 0 .. rows) {
        auto s = new string[8];
        foreach (c; 0 .. cols) {
            if (r * cols + c > 11) break;
            foreach (i, line; mons[r * cols + c])
                s[i] ~= format("   %s", line);
        }
        writeln(s.join("\n"), "\n");
    }
}

void main() {
    printCalendar(1969, 3);
}
