const std = @import("std");

/// It loops over the current state of the sandpile and updates it on-the-fly.
fn advance(field: [][]usize, boundary: *[4]usize) bool {
    // This variable is used to check whether we changed anything in the array. If no, the loop terminates.
    var done = false;

    var y = boundary[0];
    while (y < boundary[2]) : (y += 1) {
        var x = boundary[1];
        while (x < boundary[3]) : (x += 1) {
            if (field[y][x] >= 4) {
                // This part was heavily inspired by the Pascal version. We subtract 4 as many times as we can
                // and distribute it to the neighbors. Also, in case we have outgrown the current boundary, we
                // update it to once again contain the entire sandpile.

                // The amount that gets added to the neighbors is the amount here divided by four and (implicitly) floored.
                // The remaining sand is just current modulo 4.
                const rem: usize = field[y][x] / 4;
                field[y][x] = field[y][x] % 4;

                if (y > 0) {
                    field[y - 1][x] += rem;
                    if (y == boundary[0]) {
                        boundary[0] -= 1;
                    }
                }
                if (x > 0) {
                    field[y][x - 1] += rem;
                    if (x == boundary[1]) {
                        boundary[1] -= 1;
                    }
                }
                if (y + 1 < field.len) {
                    field[y + 1][x] += rem;
                    if (y == boundary[2] - 1) {
                        boundary[2] += 1;
                    }
                }
                if (x + 1 < field.len) {
                    field[y][x + 1] += rem;
                    if (x == boundary[3] - 1) {
                        boundary[3] += 1;
                    }
                }

                done = true;
            }
        }
    }

    return done;
}

/// This function can be used to display the sandpile in the console window.
fn display(field: [][]usize) void {
    for (field) |row| {
        for (row) |cell| {
            const c: u8 = switch (cell) {
                0 => ' ',
                1 => '.',
                2 => 'o',
                3 => 'O',
                else => '#',
            };
            std.debug.print("{c}", .{c});
        }
        std.debug.print("\n", .{});
    }
}

/// This function writes the end result to a file called "output.ppm".
fn write_pile(pile: [][]usize, allocator: std.mem.Allocator) !void {
    // We first create the file (or erase its contents if it already existed).
    const file = try std.fs.cwd().createFile("output.ppm", .{});
    defer file.close();

    // Then we add the image signature, which is "P3 <newline>[width of image] [height of image]<newline>[maximum value of color]<newline>".
    try std.fmt.format(file.writer(), "P3\n{d} {d}\n255\n", .{ pile.len, pile.len });

    for (pile) |row| {
        var line = std.ArrayList(u8).init(allocator);
        defer line.deinit();

        // We map each value in the field to a color.
        for (row) |elem| {
            const color = switch (elem) {
                0 => "100 40 15 ",
                1 => "117 87 30 ",
                2 => "181 134 47 ",
                3 => "245 182 66 ",
                else => unreachable,
            };
            try line.appendSlice(color);
        }

        try std.fmt.format(file.writer(), "{s}\n", .{line.items});
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // This is how big the final image will be. Currently the end result would be a 16x16 picture.
    const field_size: usize = 16;

    // Create the 2D array
    var playfield = try allocator.alloc([]usize, field_size);
    defer {
        for (playfield) |row| {
            allocator.free(row);
        }
        allocator.free(playfield);
    }

    for (playfield, 0..) |_, i| {
        playfield[i] = try allocator.alloc(usize, field_size);
        @memset(playfield[i], 0);
    }

    // We put the initial sand in the exact middle of the field.
    // This isn't necessary per se, but it ensures that sand can fully topple.
    var boundary = [4]usize{ field_size / 2 - 1, field_size / 2 - 1, field_size / 2, field_size / 2 };
    playfield[field_size / 2 - 1][field_size / 2 - 1] = 16;

    // This is the main loop. We update the field until it returns false, signalling that the pile reached its
    // final state.
    while (advance(playfield, &boundary)) {}

    // Once this happens, we simply display the result. Uncomment the line below to write it to a file.
    // Calling display with large field sizes is not recommended as it can easily become too large for the console.
    display(playfield);
    // try write_pile(playfield, allocator);
}
