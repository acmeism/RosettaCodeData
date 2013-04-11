import tango.io.Console;
import tango.text.stream.SimpleIterator;

void main (char[][] args) {
    foreach (word; new SimpleIterator!(char)(" ", Cin.input)) {
        // do something with each word
    }
}
