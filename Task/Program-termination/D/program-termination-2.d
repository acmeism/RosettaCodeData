import core.runtime, std.c.stdlib;

static ~this() {
    // This module destructor is called if
    // the program calls the dexit function.
    import std.stdio;
    "Called on dexit".writeln;
}

void dexit(int rc) {
    // Calling dexit() should have the same effect with regard to cleanup as as reaching the end of the main program.
    Runtime.terminate();
    exit(rc);
}

int main() {
    if(true) {
        dexit(0);
    }
    return 0;
}
