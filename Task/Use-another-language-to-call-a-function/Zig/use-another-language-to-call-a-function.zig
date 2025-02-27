export fn Query(data: [*c]u8, length: *usize) callconv(.C) c_int {
    const value = "Here I am";

    if (length.* >= value.len) {
        @memcpy(data[0..value.len], value);
        length.* = value.len;
        return 1;
    }

    return 0;
}
