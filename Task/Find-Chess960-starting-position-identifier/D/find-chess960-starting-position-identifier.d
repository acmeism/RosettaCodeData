import std.stdio : writeln, writefln;
import std.array : split;
import std.range : join;

string genChess960Position(int id) {
    string[] pos = new string[8];

    int q = id / 4;
    int r = id % 4;

    pos[r * 2 + 1] = "B"; // <<<

    q /= 4;
    r = q % 4;

    pos[r * 2] = "B"; // <<<

    q /= 6;
    r = q % 6;

    int i = 0;
    foreach (j; 0 .. 8) {
        if (pos[j] is null) {
            if (i == r) {
                i = j;
                break;
            }
            i++;
        }
    }

    pos[i] = "Q"; // <<<

    ////////////////////

    string[] krn = [
                        "NNRKR", "NRNKR", "NRKNR", "NRKRN",
                        "RNNKR", "RNKNR", "RNKRN",
                        "RKNNR", "RKNRN",
                        "RKRNN"
                    ];

    string krnString = krn[q];
    auto krnChars = krnString.split(""); // <<<

    i = 0;
    foreach (j; 0 .. 8) {
        if (pos[j] is null) {
            pos[j] = krnChars[i++]; // <<<
        }
    }

    ////////////////////

    return pos.join("");
}

void main() {
    writeln;

    writeln("Chess960 Position List by SP-ID");
    writeln;

    foreach (id; 0..3+1) {
        writefln("%3s : %s", id, genChess960Position(id));
    }

    "...   ........".writeln;
    writeln;

    foreach (id; [518]) {
        writefln("%3s : %s", id, genChess960Position(id));
    }

    "...   ........".writeln;
    writeln;

    foreach (id; 956..959+1) {
        writefln("%3s : %s", id, genChess960Position(id));
    }

    writeln;
}
