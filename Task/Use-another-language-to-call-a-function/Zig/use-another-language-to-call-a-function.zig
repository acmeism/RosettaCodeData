const std = @import("std");

export fn Query(Data: [*c]u8, Length: *usize) callconv(.C) c_int {
    const value = "Here I am";

    if (Length.* >= value.len) {
        @memcpy(@ptrCast([*]u8, Data), value, value.len);
        Length.* = value.len;
        return 1;
    }

    return 0;
}
