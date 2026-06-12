import std.stdio, std.getopt;

void main(string[] args) {
    string data = "file.dat";
    int length = 24;
    bool verbose;
    enum Color { no, yes }
    Color color;

    args.getopt("length",  &length,  // Integer.
                "file",    &data,    // String.
                "verbose", &verbose, // Boolean flag.
                "color",   &color);  // Enum.

    writeln("length: ", length);
    writeln("file: ", data);
    writeln("verbose: ", verbose);
    writeln("color: ", color);
}
