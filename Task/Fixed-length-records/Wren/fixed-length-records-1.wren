import "io" for File
import "./str" for Str

var records = File.read("infile.dat")
File.create("outfile.dat") { |f|
    for (record in Str.chunks(records, 80)) {
        record = record[-1..0]
        f.writeBytes(record)
    }
}
records = File.read("outfile.dat")
for (record in Str.chunks(records, 80)) System.print(record)
