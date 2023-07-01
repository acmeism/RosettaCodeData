import std.algorithm : sort;
import std.array : appender, split;
import std.range : take;
import std.stdio : File, writefln, writeln;
import std.typecons : Tuple;
import std.uni : toLower;

//Container for a word and how many times it has been seen
alias Pair = Tuple!(string, "k", int, "v");

void main() {
    int[string] wcnt;

    //Read the file line by line
    foreach (line; File("135-0.txt").byLine) {
        //Split the words on whitespace
        foreach (word; line.split) {
            //Increment the times the word has been seen
            wcnt[word.toLower.idup]++;
        }
    }

    //Associative arrays cannot be sort, so put the key/value in an array
    auto wb = appender!(Pair[]);
    foreach(k,v; wcnt) {
        wb.put(Pair(k,v));
    }
    Pair[] sw = wb.data.dup;

    //Sort the array, and display the top ten values
    writeln("Rank  Word        Frequency");
    int rank=1;
    foreach (word; sw.sort!"a.v>b.v".take(10)) {
        writefln("%4s  %-10s  %9s", rank++, word.k, word.v);
    }
}
