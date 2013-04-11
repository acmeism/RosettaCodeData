import std.stdio, std.path, std.file, std.stream;
// NB: mmfile can treat the file as an array in memory
import std.mmfile;

string[] generateTwoNames(string name) {
    string cwd  = curdir ~ sep; // on current directory
    string root = sep;          // on root

    // remove path, left only basename
    name = std.path.getBaseName(name);

    // NB: in D ver.2, getBaseName is alias of basename
    return [cwd ~ name, root ~ name];
}

void testsize(string fileName1) {
    foreach (fileName2; generateTwoNames(fileName1)) {
        try {
            writefln("File %s has size:", fileName2);
            writefln("%10d bytes by std.file.getSize (function),",
                     std.file.getSize(fileName2));
            writefln("%10d bytes by std.stream (class),",
                     (new std.stream.File(fileName2)).size);
            writefln("%10d bytes by std.mmfile (class).",
                     (new std.mmfile.MmFile(fileName2)).length);
        } catch (Exception e) {
            writefln(e.msg);
        }
        writeln();
    }
}

void main() {
    testsize(r"input.txt");
}
