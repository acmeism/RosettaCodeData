void main(in string[] args) {
    import std.stdio, std.conv, std.string;

    const fileNames = (args.length == 1) ? ["readings.txt"] :
                                           args[1 .. $];

    int noData, noDataMax = -1;
    string[] noDataMaxLine;

    double fileTotal = 0.0;
    int fileValues;

    foreach (const fileName; fileNames) {
        foreach (char[] line; fileName.File.byLine) {
            double lineTotal = 0.0;
            int lineValues;

            // Extract field info.
            const parts = line.split;
            const date = parts[0];
            const fields = parts[1 .. $];
            assert(fields.length % 2 == 0,
                   format("Expected even number of fields, not %d.",
                          fields.length));

            for (int i; i < fields.length; i += 2) {
                immutable value = fields[i].to!double;
                immutable flag = fields[i + 1].to!int;

                if (flag < 1) {
                    noData++;
                    continue;
                }

                // Check run of data-absent fields.
                if (noDataMax == noData && noData > 0)
                    noDataMaxLine ~= date.idup;

                if (noDataMax < noData && noData > 0) {
                    noDataMax = noData;
                    noDataMaxLine.length = 1;
                    noDataMaxLine[0] = date.idup;
                }

                // Re-initialise run of noData counter.
                noData = 0;

                // Gather values for averaging.
                lineTotal += value;
                lineValues++;
            }

            // Totals for the file so far.
            fileTotal += lineTotal;
            fileValues += lineValues;

            writefln("Line: %11s  Reject: %2d  Accept: %2d" ~
                     "  Line_tot: %10.3f  Line_avg: %10.3f",
                     date,
                     fields.length / 2 - lineValues,
                     lineValues,
                     lineTotal,
                     (lineValues > 0) ? lineTotal / lineValues : 0.0);
        }
    }

    writefln("\nFile(s)  = %-(%s, %)", fileNames);
    writefln("Total    = %10.3f", fileTotal);
    writefln("Readings = %6d", fileValues);
    writefln("Average  = %10.3f", fileTotal / fileValues);

    writefln("\nMaximum run(s) of %d consecutive false " ~
             "readings ends at line starting with date(s): %-(%s, %)",
             noDataMax, noDataMaxLine);
}
