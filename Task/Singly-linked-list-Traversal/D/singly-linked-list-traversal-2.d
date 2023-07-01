import tango.io.Stdout;
import tango.util.collection.LinkSeq;

void main() {
    auto m = new LinkSeq!(char[]);
    m.append("alpha");
    m.append("bravo");
    m.append("charlie");
    foreach (val; m)
        Stdout(val).newline;
}
