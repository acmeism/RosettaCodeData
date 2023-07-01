import std.algorithm : countUntil, each, map;
import std.array : array;
import std.conv : to;
import std.range : empty, retro;
import std.stdio : writeln;
import std.string : strip;
import std.typecons : tuple;

immutable LEFT_DIGITS = [
    "   ## #",
    "  ##  #",
    "  #  ##",
    " #### #",
    " #   ##",
    " ##   #",
    " # ####",
    " ### ##",
    " ## ###",
    "   # ##"
];
immutable RIGHT_DIGITS = LEFT_DIGITS.map!`a.map!"a == '#' ? ' ' : '#'".array`.array;

immutable END_SENTINEL = "# #";
immutable MID_SENTINEL = " # # ";

void decodeUPC(string input) {
    auto decode(string candidate) {
        int[] output;
        size_t pos = 0;

        auto next = pos + END_SENTINEL.length;
        auto part = candidate[pos .. next];
        if (part == END_SENTINEL) {
            pos = next;
        } else {
            return tuple(false, cast(int[])[]);
        }

        foreach (_; 0..6) {
            next = pos + 7;
            part = candidate[pos .. next];
            auto i = countUntil(LEFT_DIGITS, part);
            if (i >= 0) {
                output ~= i;
                pos = next;
            } else {
                return tuple(false, cast(int[])[]);
            }
        }

        next = pos + MID_SENTINEL.length;
        part = candidate[pos .. next];
        if (part == MID_SENTINEL) {
            pos = next;
        } else {
            return tuple(false, cast(int[])[]);
        }

        foreach (_; 0..6) {
            next = pos + 7;
            part = candidate[pos .. next];
            auto i = countUntil(RIGHT_DIGITS, part);
            if (i >= 0) {
                output ~= i;
                pos = next;
            } else {
                return tuple(false, cast(int[])[]);
            }
        }

        next = pos + END_SENTINEL.length;
        part = candidate[pos .. next];
        if (part == END_SENTINEL) {
            pos = next;
        } else {
            return tuple(false, cast(int[])[]);
        }

        int sum = 0;
        foreach (i,v; output) {
            if (i % 2 == 0) {
                sum += 3 * v;
            } else {
                sum += v;
            }
        }
        return tuple(sum % 10 == 0, output);
    }

    auto candidate = input.strip;
    auto output = decode(candidate);
    if (output[0]) {
        writeln(output[1]);
    } else {
        output = decode(candidate.retro.array.to!string);
        if (output[0]) {
            writeln(output[1], " Upside down");
        } else if (output[1].empty) {
            writeln("Invalid digit(s)");
        } else {
            writeln("Invalid checksum", output);
        }
    }
}

void main() {
    auto barcodes = [
        "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ",
        "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ",
        "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ",
        "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ",
        "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ",
        "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ",
        "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ",
        "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ",
        "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ",
        "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         ",
    ];
    barcodes.each!decodeUPC;
}
