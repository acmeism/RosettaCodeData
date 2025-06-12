import std.stdio;
import std.random;
import std.algorithm;
import std.range;

string[] ch960startPos() {
    string[] rank = new string[8];

    auto d = (size_t num) => uniform(0, num);

    auto emptySquares = () {
        return rank.enumerate
                   .filter!(t => t.value is null)
                   .map!(t => t.index)
                   .array();
    };

    // Place one Bishop << on a black square
    rank[d(4) * 2] = "♗";

    // Place the other Bishop << on a white square
    rank[d(4) * 2 + 1] = "♗";

    // Place the Queen <<
    auto empty = emptySquares();
    rank[empty[d(empty.length)]] = "♕";

    // Place one Knight <<
    empty = emptySquares();
    rank[empty[d(empty.length)]] = "♘";

    // Place the second Knight <<
    empty = emptySquares();
    rank[empty[d(empty.length)]] = "♘";

    // Remaining positions: place 2 Rooks << and 1 King <<
    empty = emptySquares();
    empty.sort();  // Sort positions for easier logic

    size_t kingPosIndex = d(empty.length);
    size_t kingPos = empty[kingPosIndex];

    auto left = empty[0 .. kingPosIndex];
    auto right = empty[kingPosIndex + 1 .. $];

    if (left.empty || right.empty) {
        // Invalid setup, retry
        return ch960startPos();
    }

    size_t rook1 = left[d(left.length)];
    size_t rook2 = right[d(right.length)];

    rank[rook1] = "♖";
    rank[kingPos] = "♔";
    rank[rook2] = "♖";

    return rank;
}

void main() {
    iota(10).each!(_ => writeln(ch960startPos().join("")));
}
