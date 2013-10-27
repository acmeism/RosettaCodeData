void main() {
    import std.stdio, std.array, std.string, std.regex, std.conv,
           std.algorithm;

    auto rxDate = `^\d\d\d\d-\d\d-\d\d$`.regex;
    // Works but eats lot of RAM in DMD 2.064.
    // auto rxDate = ctRegex!(`^\d\d\d\d-\d\d-\d\d$`);

    int[string] repeatedDates;
    int goodReadings;
    foreach (string line; "readings.txt".File.lines) {
        try {
            auto parts = line.split;
            if (parts.length != 49)
                throw new Exception("Wrong column count");
            if (parts[0].match(rxDate).empty)
                throw new Exception("Date is wrong");
            repeatedDates[parts[0]]++;
            bool noProblem = true;
            for (int i = 1; i < 48; i += 2) {
                if (parts[i + 1].to!int < 1)
                    // don't break loop because it's validation too.
                    noProblem = false;
                if (!parts[i].isNumeric)
                    throw new Exception("Reading is wrong: "~parts[i]);
            }
            if (noProblem)
                goodReadings++;
        } catch(Exception ex) {
            writefln(`Problem in line "%s": %s`, line, ex);
        }
    }

    writefln("Duplicated timestamps: %-(%s, %)",
            repeatedDates.byKey.filter!(k => repeatedDates[k] > 1));
    writeln("Good reading records: ", goodReadings);
}
