import std.stdio, std.array, std.string, std.regex, std.conv,
       std.algorithm;

void main() {
    // works but eats lot of RAM in DMD 2.059
    //const rxDate = ctRegex!(`^\d\d\d\d-\d\d-\d\d$`);
    auto rxDate = regex(`^\d\d\d\d-\d\d-\d\d$`);

    int[string] repeatedDates;
    int goodReadings;
    foreach (string line; lines(File("readings.txt"))) {
        try {
            auto parts = line.split();
            if (parts.length != 49)
                throw new Exception("Wrong column count");
            if (match(parts[0], rxDate).empty)
                throw new Exception("Date is wrong");
            repeatedDates[parts[0]]++;
            bool noProblem = true;
            for (int i = 1; i < 48; i += 2) {
                if (to!int(parts[i + 1]) < 1)
                    // don't break loop because it's validation too.
                    noProblem = false;
                if (!isNumeric(parts[i]))
                    throw new Exception("Reading is wrong: "~parts[i]);
            }
            if (noProblem)
                goodReadings++;
        } catch(Exception ex) {
            writefln(`Problem in line "%s": %s`, line, ex);
        }
    }

    writeln("Duplicated timestamps: ",
            repeatedDates.keys.filter!(k => repeatedDates[k] > 1)().
            join(", "));
    writeln("Good reading records: ", goodReadings);
}
