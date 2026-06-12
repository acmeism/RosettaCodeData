const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const HashMap = std.HashMap;
const Allocator = std.mem.Allocator;
const Random = std.Random;

fn printOneBasedVector(list: []const i32) void {
    print("["  , .{});
    if (list.len > 0) {
        for (list[0..list.len - 1]) |val| {
            print("{}, ",  .{val + 1} );
        }
        print("{}]", .{ list[list.len - 1] + 1 });
    } else {
        print("]" , .{});
    }
}

fn print2dVector(lists: []const []const i32) void {
    print("[" , .{});
    if (lists.len > 0) {
        for (lists[0..lists.len - 1]) |row| {
            printOneBasedVector(row);
            print(", "  , .{});
        }
        printOneBasedVector(lists[lists.len - 1]);
    }
    print("]"  , .{});
}

fn createCube(allocator: Allocator, matrix: []const []const i32, size: usize) ![][][] i32 {
    // Allocate 3D array
    var cube = try allocator.alloc([][]i32, size);
    for (cube) |*plane| {
        plane.* = try allocator.alloc([]i32, size);
        for (plane.*) |*row| {
            row.* = try allocator.alloc(i32, size);
            @memset(row.*, 0);
        }
    }

    for (0..size) |i| {
        for (0..size) |j| {
            const k: usize = if (matrix.len == 0)
                (i + j) % size
            else
                @intCast(matrix[i][j] - 1);
            cube[i][j][k] = 1;
        }
    }

    return cube;
}

fn shuffleCube(cube: [][][]i32, rng: Random) void {
    var proper = true;
    const size = cube.len;

    // Find a random zero position
    var rx: usize = undefined;
    var ry: usize = undefined;
    var rz: usize = undefined;

    while (true) {
        rx = rng.intRangeLessThan(usize, 0, size);
        ry = rng.intRangeLessThan(usize, 0, size);
        rz = rng.intRangeLessThan(usize, 0, size);
        if (cube[rx][ry][rz] == 0) {
            break;
        }
    }

    while (true) {
        var ox: usize = 0;
        var oy: usize = 0;
        var oz: usize = 0;

        // Find the 1s in the same planes
        while (cube[ox][ry][rz] != 1) {
            ox += 1;
        }
        while (cube[rx][oy][rz] != 1) {
            oy += 1;
        }
        while (cube[rx][ry][oz] != 1) {
            oz += 1;
        }

        if (!proper) {
            if (rng.boolean()) {
                ox += 1;
                while (cube[ox][ry][rz] != 1) {
                    ox += 1;
                }
            }
            if (rng.boolean()) {
                oy += 1;
                while (cube[rx][oy][rz] != 1) {
                    oy += 1;
                }
            }
            if (rng.boolean()) {
                oz += 1;
                while (cube[rx][ry][oz] != 1) {
                    oz += 1;
                }
            }
        }

        // Perform the shuffle operation
        cube[rx][ry][rz] += 1;
        cube[rx][oy][oz] += 1;
        cube[ox][ry][oz] += 1;
        cube[ox][oy][rz] += 1;

        cube[rx][ry][oz] -= 1;
        cube[rx][oy][rz] -= 1;
        cube[ox][ry][rz] -= 1;
        cube[ox][oy][oz] -= 1;

        if (cube[ox][oy][oz] < 0) {
            rx = ox;
            ry = oy;
            rz = oz;
            proper = false;
        } else {
            break;
        }
    }
}

fn toMatrix(allocator: Allocator, cube: [][][]const i32) ![][]i32 {
    const size = cube.len;
    var matrix = try allocator.alloc([]i32, size);
    for (matrix) |*row| {
        row.* = try allocator.alloc(i32, size);
        @memset(row.*, 0);
    }

    for (0..size) |i| {
        for (0..size) |j| {
            for (0..size) |k| {
                if (cube[i][j][k] != 0) {
                    matrix[i][j] = @intCast(k);
                    break;
                }
            }
        }
    }

    return matrix;
}

fn reduce(matrix: [][]i32) void {
    const size = matrix.len;

    // Normalize first row
    for (0..size - 1) |j| {
        if (matrix[0][j] != @as(i32, @intCast(j))) {
            for (j + 1..size) |k| {
                if (matrix[0][k] == @as(i32, @intCast(j))) {
                    for (0..size) |i| {
                        const temp = matrix[i][j];
                        matrix[i][j] = matrix[i][k];
                        matrix[i][k] = temp;
                    }
                    break;
                }
            }
        }
    }

    // Normalize first column
    for (1..size - 1) |i| {
        if (matrix[i][0] != @as(i32, @intCast(i))) {
            for (i + 1..size) |k| {
                if (matrix[k][0] == @as(i32, @intCast(i))) {
                    const temp_row = matrix[i];
                    matrix[i] = matrix[k];
                    matrix[k] = temp_row;
                    break;
                }
            }
        }
    }
}

// Custom hash function for matrix
fn matrixHash(matrix: []const []const i32) u64 {
    var hasher = std.hash.Wyhash.init(0);
    for (matrix) |row| {
        for (row) |val| {
            hasher.update(std.mem.asBytes(&val));
        }
    }
    return hasher.final();
}

// Custom equality function for matrix
fn matrixEql(a: []const []const i32, b: []const []const i32) bool {
    if (a.len != b.len) return false;
    for (a, b) |row_a, row_b| {
        if (row_a.len != row_b.len) return false;
        for (row_a, row_b) |val_a, val_b| {
            if (val_a != val_b) return false;
        }
    }
    return true;
}

const MatrixContext = struct {
    pub fn hash(self: @This(), matrix: []const []const i32) u64 {
        _ = self;
        return matrixHash(matrix);
    }

    pub fn eql(self: @This(), a: []const []const i32, b: []const []const i32) bool {
        _ = self;
        return matrixEql(a, b);
    }
};

fn freeCube(allocator: Allocator, cube: [][][]i32) void {
    for (cube) |plane| {
        for (plane) |row| {
            allocator.free(row);
        }
        allocator.free(plane);
    }
    allocator.free(cube);
}

fn freeMatrix(allocator: Allocator, matrix: [][]i32) void {
    for (matrix) |row| {
        allocator.free(row);
    }
    allocator.free(matrix);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var rng = std.Random.DefaultPrng.init(@intCast(std.time.milliTimestamp()));
    const random = rng.random();

    print("PART 1: 10,000 latin Squares of order 4 in reduced form:\n\n"  , .{});

    // Create original 4x4 matrix
    var original_4_data = [_][4]i32{
        [_]i32{ 1, 2, 3, 4 },
        [_]i32{ 2, 1, 4, 3 },
        [_]i32{ 3, 4, 1, 2 },
        [_]i32{ 4, 3, 2, 1 },
    };
    var original_4 = [_][]i32{
        &original_4_data[0],
        &original_4_data[1],
        &original_4_data[2],
        &original_4_data[3],
    };

    var frequencies = HashMap([]const []const i32, u32, MatrixContext, std.hash_map.default_max_load_percentage).init(allocator);
    defer frequencies.deinit();

    var cube = try createCube(allocator, &original_4, 4);
    defer freeCube(allocator, cube);

    var stored_matrices = ArrayList([][]i32).init(allocator);
    defer {
        for (stored_matrices.items) |matrix| {
            freeMatrix(allocator, matrix);
        }
        stored_matrices.deinit();
    }

    for (0..10_000) |_| {
        shuffleCube(cube, random);
        const matrix = try toMatrix(allocator, cube);
        reduce(matrix);

        // Check if we already have this matrix
        var found = false;
        var existing_count: u32 = 0;
        for (stored_matrices.items) |stored| {
            if (matrixEql(stored, matrix)) {
                found = true;
                existing_count = frequencies.get(stored).?;
                _ = frequencies.remove(stored);
                try frequencies.put(stored, existing_count + 1);
                freeMatrix(allocator, matrix);
                break;
            }
        }

        if (!found) {
            try stored_matrices.append(matrix);
            try frequencies.put(matrix, 1);
        }
    }

    var it = frequencies.iterator();
    while (it.next()) |entry| {
        print2dVector(entry.key_ptr.*);
        print(" occurs {} times\n", .{entry.value_ptr.*});
    }

    print("\nPART 2: 10_000 latin squares of order 5 in reduced form:"  , .{});

    // Create original 5x5 matrix
    var original_5_data = [_][5]i32{
        [_]i32{ 1, 2, 3, 4, 5 },
        [_]i32{ 2, 3, 4, 5, 1 },
        [_]i32{ 3, 4, 5, 1, 2 },
        [_]i32{ 4, 5, 1, 2, 3 },
        [_]i32{ 5, 1, 2, 3, 4 },
    };
    var original_5 = [_][]i32{
        &original_5_data[0],
        &original_5_data[1],
        &original_5_data[2],
        &original_5_data[3],
        &original_5_data[4],
    };

    frequencies.clearAndFree();
    for (stored_matrices.items) |matrix| {
        freeMatrix(allocator, matrix);
    }
    stored_matrices.clearAndFree();

    freeCube(allocator, cube);
    cube = try createCube(allocator, &original_5, 5);

    for (0..10_000) |_| {
        shuffleCube(cube, random);
        const matrix = try toMatrix(allocator, cube);
        reduce(matrix);

        // Check if we already have this matrix
        var found = false;
        var existing_count: u32 = 0;
        for (stored_matrices.items) |stored| {
            if (matrixEql(stored, matrix)) {
                found = true;
                existing_count = frequencies.get(stored).?;
                _ = frequencies.remove(stored);
                try frequencies.put(stored, existing_count + 1);
                freeMatrix(allocator, matrix);
                break;
            }
        }

        if (!found) {
            try stored_matrices.append(matrix);
            try frequencies.put(matrix, 1);
        }
    }

    var count: u32 = 0;
    it = frequencies.iterator();
    while (it.next()) |entry| {
        count += 1;
        print("{s}{s}{:2}({:3})", .{
            if (count > 1) ", " else "",
            if (count % 8 == 1) "\n" else "",
            count,
            entry.value_ptr.*,
        });
    }

    print("\n\nPART 3: 750 latin squares of order 42, showing the last one:\n\n"  , .{});

    freeCube(allocator, cube);
    cube = try createCube(allocator, &[_][]i32{}, 42);
    var final_matrix: [][]i32 = undefined;

    for (1..(750+1)) |i| {
        shuffleCube(cube, random);
        if (i == 750) {
            final_matrix = try toMatrix(allocator, cube);
        }
    }

    for (final_matrix) |row| {
        printOneBasedVector(row);
        print("\n"  , .{});
    }

    print("\nPART 4: 1,000 latin squares of order 256:\n\n" , .{});

    const start = std.time.milliTimestamp();
    freeCube(allocator, cube);
    cube = try createCube(allocator, &[_][]i32{}, 256);

    for (0..1_000) |_| {
        shuffleCube(cube, random);
    }

    const duration = std.time.milliTimestamp() - start;
    print("Generated in {d} milliseconds\n", .{duration});

    // Cleanup
    freeMatrix(allocator, final_matrix);
    freeCube(allocator, cube);
}
