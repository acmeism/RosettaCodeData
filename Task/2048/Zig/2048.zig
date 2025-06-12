const std = @import("std");
const io = std.io;
const Random = std.Random;

// UserMove enum representing possible moves
const UserMove = enum {
    Up,
    Down,
    Left,
    Right,
};

// Game field type
const Field = [4][4]u32;

// Function to print the current game state
fn printGame(field: *const Field) void {
    for (field) |row| {
        std.debug.print("{any}\n", .{row});
    }
}

// Function to get a user move
fn getUserMove() !UserMove {
    const stdin = std.io.getStdIn().reader();
    var buf: [2]u8 = undefined; // Buffer for input (character + newline)

    while (true) {
        const bytesRead = try stdin.read(&buf);
        if (bytesRead < 1) continue;

        switch (buf[0]) {
            'a' => return UserMove.Left,
            'w' => return UserMove.Up,
            's' => return UserMove.Down,
            'd' => return UserMove.Right,
            else => {
                std.debug.print("input was {c}: invalid character should be a,s,w or d\n", .{buf[0]});
            },
        }
    }
}

// This function implements user moves.
// For every element, it checks if the element is zero.
// If the element is zero, it looks against the direction of movement if any
// element is not zero, then moves it to its place and checks for a matching element.
// If the element is not zero, it looks for a match. If no match is found,
// it looks for the next element.
fn doGameStep(step: UserMove, field: *Field) void {
    switch (step) {
        .Left => {
            for (field) |*row| {
                for (0..4) |col| {
                    for ((col + 1)..4) |my_testCol| {
                        if (row[my_testCol] != 0) {
                            if (row[col] == 0) {
                                row[col] += row[my_testCol];
                                row[my_testCol] = 0;
                            } else if (row[col] == row[my_testCol]) {
                                row[col] += row[my_testCol];
                                row[my_testCol] = 0;
                                break;
                            } else {
                                break;
                            }
                        }
                    }
                }
            }
        },
        .Right => {
            for (field) |*row| {
                var col: i32 = 3;
                while (col >= 0) : (col -= 1) {
                    var my_testCol: i32 = col - 1;
                    while (my_testCol >= 0) : (my_testCol -= 1) {
                        if (row[@intCast(my_testCol)] != 0) {
                            if (row[@intCast(col)] == 0) {
                                row[@intCast(col)] += row[@intCast(my_testCol)];
                                row[@intCast(my_testCol)] = 0;
                            } else if (row[@intCast(col)] == row[@intCast(my_testCol)]) {
                                row[@intCast(col)] += row[@intCast(my_testCol)];
                                row[@intCast(my_testCol)] = 0;
                                break;
                            } else {
                                break;
                            }
                        }
                    }
                }
            }
        },
        .Down => {
            for (0..4) |col_idx| {
                const col = col_idx; // Convert to immutable
                var row: i32 = 3;
                while (row >= 0) : (row -= 1) {
                    var my_testRow: i32 = row - 1;
                    while (my_testRow >= 0) : (my_testRow -= 1) {
                        if (field[@intCast(my_testRow)][col] != 0) {
                            if (field[@intCast(row)][col] == 0) {
                                field[@intCast(row)][col] += field[@intCast(my_testRow)][col];
                                field[@intCast(my_testRow)][col] = 0;
                            } else if (field[@intCast(row)][col] == field[@intCast(my_testRow)][col]) {
                                field[@intCast(row)][col] += field[@intCast(my_testRow)][col];
                                field[@intCast(my_testRow)][col] = 0;
                                break;
                            } else {
                                break;
                            }
                        }
                    }
                }
            }
        },
        .Up => {
            for (0..4) |col| {
                for (0..4) |row| {
                    for ((row + 1)..4) |my_testRow| {
                        if (field[my_testRow][col] != 0) {
                            if (field[row][col] == 0) {
                                field[row][col] += field[my_testRow][col];
                                field[my_testRow][col] = 0;
                            } else if (field[row][col] == field[my_testRow][col]) {
                                field[row][col] += field[my_testRow][col];
                                field[my_testRow][col] = 0;
                                break;
                            } else {
                                break;
                            }
                        }
                    }
                }
            }
        },
    }
}

// Spawn a new number (2 or 4) in a random empty cell
fn spawn(field: *Field, random: Random) void {
    while (true) {
        const x = random.uintLessThan(usize, 16); // Random position 0-15
        const row = x % 4;
        const col = (x / 4) % 4;

        if (field[row][col] == 0) {
            // 10% chance for a 4, 90% chance for a 2
            if (random.uintLessThan(usize, 10) == 0) {
                field[row][col] = 4;
            } else {
                field[row][col] = 2;
            }
            break;
        }
    }
}

// Check if fields are equal
fn areFieldsEqual(a: *const Field, b: *const Field) bool {
    for (0..4) |i| {
        for (0..4) |j| {
            if (a[i][j] != b[i][j]) return false;
        }
    }
    return true;
}

// Check if player has won (any tile equals 2048)
fn checkWin(field: *const Field) bool {
    for (field) |row| {
        for (row) |cell| {
            if (cell == 2048) return true;
        }
    }
    return false;
}

pub fn main() !void {
    var prng = std.Random.DefaultPrng.init(@intCast(std.time.milliTimestamp()));
    const random = prng.random();

    var field: Field = [_][4]u32{[_]u32{0} ** 4} ** 4;
    var my_test: Field = undefined;

    gameLoop: while (true) {
        // Check if there's still an open space
        @memcpy(&my_test, &field);
        spawn(&field, random);

        // Check if any valid moves remain
        var validMoveExists = false;
        const moves = [_]UserMove{ .Up, .Down, .Left, .Right };

        for (moves) |move| {
            @memcpy(&my_test, &field);
            doGameStep(move, &my_test);

            if (!areFieldsEqual(&my_test, &field)) {
                validMoveExists = true;
                break;
            }
        }

        if (!validMoveExists) {
            std.debug.print("No more valid moves, you lose\n", .{});
            break :gameLoop;
        }

        // Print the current game state
        printGame(&field);
        std.debug.print("move the blocks\n", .{});

        // Get and apply user move
        @memcpy(&my_test, &field);
        while (areFieldsEqual(&my_test, &field)) {
            const move = try getUserMove();
            doGameStep(move, &field);
        }

        // Check win condition
        if (checkWin(&field)) {
            printGame(&field);
            std.debug.print("You Won!!\n", .{});
            break :gameLoop;
        }
    }
}
