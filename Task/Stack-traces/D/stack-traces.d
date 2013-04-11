import std.stdio;

void inner() {
    try
        throw new Exception(null);
    catch (Exception e)
        writeln(e);

    writeln("running");
}

void middle() {
    inner();
}

void outer() {
    middle();
}

void main() {
    outer();
}
