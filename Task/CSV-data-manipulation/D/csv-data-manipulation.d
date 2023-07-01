void main() {
    import std.stdio, std.csv, std.file, std.typecons, std.array,
           std.algorithm, std.conv, std.range;

    auto rows = "csv_data_in.csv".File.byLine;
    auto fout = "csv_data_out.csv".File("w");
    fout.writeln(rows.front);
    fout.writef("%(%(%d,%)\n%)", rows.dropOne
                .map!(r => r.csvReader!int.front.map!(x => x + 1)));
}
