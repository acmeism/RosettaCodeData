import std.stdio : writeln;
import std.random;
import std.array : join;
import std.string : indexOf, lastIndexOf;
import std.algorithm : nextPermutation;

void main() {
    // The Pieces, no King at all but 3 Rooks!
    auto pos = ["Q", "R", "R", "R", "B", "B", "N", "N"].randomShuffle;

    do {
        auto candidate = pos.join("");

        if (candidate.indexOf('B') % 2 != candidate.lastIndexOf('B') % 2) {
            auto dupPos = pos.dup;

            // Promote middle Rook to King
            dupPos[candidate[0..candidate.lastIndexOf('R')].lastIndexOf('R')] = "K";

            dupPos.join("").writeln; // Output!

            return;
        }
    } while (pos.nextPermutation);
}
