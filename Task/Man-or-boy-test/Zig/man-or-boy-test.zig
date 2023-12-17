const Record = struct {
    yieldFn: *const fn (record: *Record) i32,

    k: *i32 = undefined,
    x1: *Record = undefined,
    x2: *Record = undefined,
    x3: *Record = undefined,
    x4: *Record = undefined,
    x5: *Record = undefined,

    inline fn run(record: *Record) i32 {
        return record.yieldFn(record);
    }

    pub fn A(record: *Record) i32 {
        return if (record.k.* <= 0)
            record.x4.run() + record.x5.run()
        else
            record.B();
    }

    fn B(record: *Record) i32 {
        record.k.* -= 1;

        var k_copy_on_stack: i32 = record.k.*;

        var b: Record = .{
            .yieldFn = &Record.B,

            .k = &k_copy_on_stack,
            .x1 = record,
            .x2 = record.x1,
            .x3 = record.x2,
            .x4 = record.x3,
            .x5 = record.x4,
        };
        return b.A();
    }
};

const numbers = struct {
    fn positiveOne(unused_record: *Record) i32 {
        _ = unused_record;
        return 1;
    }

    fn zero(unused_record: *Record) i32 {
        _ = unused_record;
        return 0;
    }

    fn negativeOne(unused_record: *Record) i32 {
        _ = unused_record;
        return -1;
    }
};

const std = @import("std");

pub fn main() void {
    var i: u31 = 0;
    while (i <= 31) : (i += 1) {
        var k: i32 = i;
        var @"+1_record": Record = .{ .yieldFn = &numbers.positiveOne };
        var @"0_record": Record = .{ .yieldFn = &numbers.zero };
        var @"-1_record": Record = .{ .yieldFn = &numbers.negativeOne };

        var record: Record = .{
            .yieldFn = &Record.B,

            .k = &k,
            .x1 = &@"+1_record",
            .x2 = &@"-1_record",
            .x3 = &@"-1_record",
            .x4 = &@"+1_record",
            .x5 = &@"0_record",
        };

        std.debug.print("[{d:>3}] = {d}\n", .{ i, record.A() });
    }
}
