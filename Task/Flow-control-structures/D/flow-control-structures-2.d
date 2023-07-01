import std.stdio;

class DerivedException : Exception {
    this(string msg) { super(msg); }
}

void main(string[] args) {
    try {
        if (args[1] == "throw")
            throw new Exception("message");
    } catch (DerivedException ex) {
        // We never threw a DerivedException, so this
        // block is never called.
        writefln("caught derived exception %s", ex);
    } catch (Exception ex) {
        writefln("caught exception: %s", ex);
    } catch (Throwable ex) {
        writefln("caught throwable: %s", ex);
    } finally {
        writeln("finished (exception or none).");
    }
}
