import tango.core.Thread;
import tango.io.Console;
import tango.math.Random;

void main() {
    (new Thread( { Thread.sleep(Random.shared.next(1000) / 1000.0); Cout("Enjoy").newline; } )).start;
    (new Thread( { Thread.sleep(Random.shared.next(1000) / 1000.0); Cout("Rosetta").newline; } )).start;
    (new Thread( { Thread.sleep(Random.shared.next(1000) / 1000.0); Cout("Code").newline; } )).start;
}
