const std = @import("std");

const Ctrl = enum(u8) {
    nul,
    soh,
    stx,
    etx,
    eot,
    enq,
    ack,
    bel,
    bs,
    ht,
    lf,
    vt,
    ff,
    cr,
    so,
    si,
    dle,
    dc1,
    dc2,
    dc3,
    dc4,
    nak,
    syn,
    etb,
    can,
    em,
    sub,
    esc,
    fs,
    gs,
    rs,
    us,
    space,
    del = 127,
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{s} {d}\n", .{@tagName(Ctrl.em), @intFromEnum(Ctrl.em)});
    try stdout.print("{s} {d}\n", .{@tagName(Ctrl.del), @intFromEnum(Ctrl.del)});
}
