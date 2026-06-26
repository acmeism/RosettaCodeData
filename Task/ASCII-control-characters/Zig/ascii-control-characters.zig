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

pub fn main(init: std.process.Init) !void {
    var stdout = std.Io.File.stdout().writer(init.io, &.{});

    try stdout.interface.print("{t} {d}\n", .{Ctrl.em, @intFromEnum(Ctrl.em)});
    try stdout.interface.print("{t} {d}\n", .{Ctrl.del, @intFromEnum(Ctrl.del)});
}
