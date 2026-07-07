const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io: std.Io = init.io;
    var stdouter_buf: [512]u8 = undefined;
    var stdouter = std.Io.File.stdout().writer(io, &stdouter_buf);

    var array = [_]i32{ 1, 4, 65, 2, -31, 0, 99, 2, 83, 782, 1 };
    for (0..array.len) |i| try stdouter.interface.print("{d},", .{array[i]});
    try stdouter.interface.print("\n", .{});
    cyclesort(&array);
    for (0..array.len) |i| try stdouter.interface.print("{d},", .{array[i]});
    try stdouter.flush();
}

fn cyclesort(arr: []i32) void {
    for (0..arr.len - 1) |start| {
        var j: i32 = arr[start];
        var first: bool = true;
        while (true) {
            var count: usize = start;
            var tmp: i32 = undefined;
            for (start + 1..arr.len) |k| {
                count += if (j > arr[k]) 1 else 0;
            }
            if (first and count == start) break;
            while (j == arr[count] and count + 1 < arr.len) count += 1;
            tmp = arr[count];
            arr[count] = j;
            j = tmp;
            if (count == start) break;
            first = false;
        }
    }
}
