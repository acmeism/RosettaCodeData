import tango.io.Console;
import tango.text.stream.LineIterator;

void main (char[][] args) {
    foreach (line; new LineIterator!(char)(Cin.input)) {
        // do something with each line
    }
}
