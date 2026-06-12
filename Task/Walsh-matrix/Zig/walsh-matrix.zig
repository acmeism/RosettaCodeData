const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

fn display(matrix: []const []const i32) void {
    for (matrix) |row| {
        for (row) |element| {
            print("{:3}", .{element});
        }
        print("\n" , .{});
    }
    print("\n" , .{});
}

fn signChangeCount(row: []const i32) u32 {
    var sign_changes: u32 = 0;
    var i: usize = 1;
    while (i < row.len) : (i += 1) {
        if (row[i - 1] == -row[i]) {
            sign_changes += 1;
        }
    }
    return sign_changes;
}

fn walshMatrix(allocator: Allocator, size: u32) ![][]i32 {
    const usize_size = @as(usize, size);

    // Allocate matrix
    var walsh = try allocator.alloc([]i32, usize_size);
    for (walsh) |*row| {
        row.* = try allocator.alloc(i32, usize_size);
        @memset(row.*, 0);
    }

    walsh[0][0] = 1;

    var k: usize = 1;
    while (k < usize_size) {
        var i: usize = 0;
        while (i < k) : (i += 1) {
            var j: usize = 0;
            while (j < k) : (j += 1) {
                walsh[i + k][j] = walsh[i][j];
                walsh[i][j + k] = walsh[i][j];
                walsh[i + k][j + k] = -walsh[i][j];
            }
        }
        k += k;
    }

    return walsh;
}

fn freeMatrix(allocator: Allocator, matrix: [][]i32) void {
    for (matrix) |row| {
        allocator.free(row);
    }
    allocator.free(matrix);
}

fn compareRows(context: void, row1: []const i32, row2: []const i32) bool {
    _ = context;
    return signChangeCount(row1) < signChangeCount(row2);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const types = [_][]const u8{ "Natural", "Sequency" };
    const orders = [_]u32{ 2, 4, 5 };

    for (types) |matrix_type| {
        for (orders) |order| {
            const size = @as(u32, 1) << @intCast(order);
            print("Walsh matrix of order {any}, {s} order:\n", .{ order, matrix_type });

            const walsh = try walshMatrix(allocator, size);
            defer freeMatrix(allocator, walsh);

            if (std.mem.eql(u8, matrix_type, "Sequency")) {
                std.mem.sort([]i32, walsh, {}, compareRows);
            }

            display(walsh);
        }
    }
}
