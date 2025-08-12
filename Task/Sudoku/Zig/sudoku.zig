const std = @import("std");

const Sudoku = [81]u8;

fn isValid(val: u8, x: usize, y: usize, sudokuAr: *Sudoku) bool {
    // Check row and column
    for (0..9) |i| {
        if (sudokuAr[y * 9 + i] == val or sudokuAr[i * 9 + x] == val) {
            return false;
        }
    }

    // Check 3x3 box
    const startX = (x / 3) * 3;
    const startY = (y / 3) * 3;

    for (startY..startY + 3) |i| {
        for (startX..startX + 3) |j| {
            if (sudokuAr[i * 9 + j] == val) {
                return false;
            }
        }
    }

    return true;
}

fn placeNumber(pos: usize, sudokuAr: *Sudoku) bool {
    var currentPos: usize = pos;

    // Find next empty cell
    while (currentPos < 81 and sudokuAr[currentPos] != 0) {
        currentPos += 1;
    }

    // If no empty cells, puzzle is solved
    if (currentPos >= 81) {
        return true;
    }

    const x = currentPos % 9;
    const y = currentPos / 9;

    // Try placing digits 1-9
    for (1..10) |n| {
        if (isValid(@intCast(n), x, y, sudokuAr)) {
            sudokuAr[currentPos] = @intCast(n);

            if (placeNumber(currentPos + 1, sudokuAr)) {
                return true;
            }

            // Backtrack
            sudokuAr[currentPos] = 0;
        }
    }

    return false;
}

fn prettyPrint(sudokuAr: Sudoku) void {
    const lineSep = "------+-------+------";
    std.debug.print("{s}\n", .{lineSep});

    for (0..81) |i| {
        std.debug.print("{d} ", .{sudokuAr[i]});

        if ((i + 1) % 3 == 0 and (i + 1) % 9 != 0) {
            std.debug.print("| ", .{});
        }

        if ((i + 1) % 9 == 0) {
            std.debug.print("\n", .{});
        }

        if ((i + 1) % 27 == 0) {
            std.debug.print("{s}\n", .{lineSep});
        }
    }
}

fn solve(sudokuAr: *Sudoku) bool {
    return placeNumber(0, sudokuAr);
}

pub fn main() !void {
    var sudokuAr: Sudoku = [_]u8{
        8, 5, 0, 0, 0, 2, 4, 0, 0,
        7, 2, 0, 0, 0, 0, 0, 0, 9,
        0, 0, 4, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 1, 0, 7, 0, 0, 2,
        3, 0, 5, 0, 0, 0, 9, 0, 0,
        0, 4, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 8, 0, 0, 7, 0,
        0, 1, 7, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 3, 6, 0, 4, 0
    };

    if (solve(&sudokuAr)) {
        prettyPrint(sudokuAr);
    } else {
        std.debug.print("Unsolvable\n", .{});
    }
}
