void main() {
    import std.stdio;

    immutable fileName = "input_loop1.d";

    foreach (const line; fileName.File.byLine) {
        pragma(msg, typeof(line)); // Prints: const(char[])
        // line is a transient slice, so if you need to
        // retain it for later use, you have to .dup or .idup it.
        line.writeln; // Do something with each line.
    }

    // Keeping the line terminators:
    foreach (const line; fileName.File.byLine(KeepTerminator.yes)) {
        // line is a transient slice.
        line.writeln;
    }

    foreach (const string line; fileName.File.lines) {
        // line is a transient slice.
        line.writeln;
    }
}
