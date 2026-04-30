const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const WIDTH: usize = 6;

const SqMat = struct {
    data: ArrayList(ArrayList(i64)),
    allocator: Allocator,

    const Self = @This();

    pub fn init(allocator: Allocator, mat_size: usize) !Self {
        var mat = Self{
            .data = ArrayList(ArrayList(i64)){},
            .allocator = allocator,
        };

        for (0..mat_size) |_| {
            var row = ArrayList(i64){};
            for (0..mat_size) |_| {
                try row.append(allocator, 0);
            }
            try mat.data.append(allocator, row);
        }

        return mat;
    }

    pub fn initWithData(allocator: Allocator, data: []const []const i64) !Self {
        var mat = Self{
            .data = ArrayList(ArrayList(i64)){},
            .allocator = allocator,
        };

        for (data) |row_data| {
            var row = ArrayList(i64){};
            for (row_data) |val| {
                try row.append(allocator, val);
            }
            try mat.data.append(allocator, row);
        }

        return mat;
    }

    // pub fn deinit(self: *Self) void {
    //     for (self.data.items) |*row| {
    //         row.deinit();
    //     }
    //     self.data.deinit();
    // }

    pub fn clone(self: *const Self) !Self {
        var new_mat = Self{
            .data = ArrayList(ArrayList(i64)){},
            .allocator = self.allocator,
        };

        for (self.data.items) |row| {
            var new_row = ArrayList(i64){};
            for (row.items) |val| {
                try new_row.append(self.allocator, val);
            }
            try new_mat.data.append(self.allocator, new_row);
        }

        return new_mat;
    }


    pub fn printMatrix(self: *const Self) void {
        for (self.data.items) |row| {
            for (row.items) |val| {
                print("{d:>6} ", .{val});
            }
            print("\n" , .{});
        }
    }

    pub fn size(self: *const Self) usize {
        return self.data.items.len;
    }

    pub fn format(self: Self, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        _ = fmt;
        _ = options;

        for (self.data.items) |row| {
            for (row.items) |val| {
                try writer.print("{d:>6} ", .{val});
            }
            try writer.print("\n");
        }
    }

    pub fn pow(self: *const Self, n: u32) !Self {
        const mat_size = self.size();
        var aux_data = try self.clone();
        //defer aux_data.deinit();

        // Initialize identity matrix
        var ans = try Self.init(self.allocator, mat_size);
        for (0..mat_size) |i| {
            ans.data.items[i].items[i] = 1;
        }

        var b = n;
        while (b > 0) {
            if (b & 1 > 0) {
                // ans = ans * aux
                var tmp = try Self.init(self.allocator, mat_size);
                // defer tmp.deinit();

                for (0..mat_size) |i| {
                    for (0..mat_size) |j| {
                        tmp.data.items[i].items[j] = 0;
                        for (0..mat_size) |k| {
                            tmp.data.items[i].items[j] += ans.data.items[i].items[k] * aux_data.data.items[k].items[j];
                        }
                    }
                }

                // Copy tmp to ans
                for (0..mat_size) |i| {
                    for (0..mat_size) |j| {
                        ans.data.items[i].items[j] = tmp.data.items[i].items[j];
                    }
                }
            }

            b >>= 1;
            if (b > 0) {
                // aux = aux * aux
                var tmp = try Self.init(self.allocator, mat_size);
                // defer tmp.deinit();

                for (0..mat_size) |i| {
                    for (0..mat_size) |j| {
                        tmp.data.items[i].items[j] = 0;
                        for (0..mat_size) |k| {
                            tmp.data.items[i].items[j] += aux_data.data.items[i].items[k] * aux_data.data.items[k].items[j];
                        }
                    }
                }

                // Copy tmp to aux_data
                for (0..mat_size) |i| {
                    for (0..mat_size) |j| {
                        aux_data.data.items[i].items[j] = tmp.data.items[i].items[j];
                    }
                }
            }
        }

        return ans;
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const matrix_data = [_][]const i64{
        &[_]i64{ 1, 2, 0 },
        &[_]i64{ 0, 3, 1 },
        &[_]i64{ 1, 0, 0 },
    };

    var sm = try SqMat.initWithData(allocator, &matrix_data);
    // defer sm.deinit();

    for (0..11) |i| {
        var result = try sm.pow(@intCast(i));
        // defer result.deinit();
        print("Power of {d}:\n", .{i});
        result.printMatrix();
        print("\n" , .{});
    }
}
