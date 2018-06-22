import std.stdio;

void main() {
    version(Windows) {
        File f = File("TAPE.FILE", "w");
    } else {
        File f = File("/dev/tape", "w");
    }
    f.writeln("Hello World!");
}
