const std = @import("std");
const builtin = @import("builtin");

pub const first_integer_constant: i32 = 5;
pub const second_integer_constant: i32 = 3;
pub const third_integer_constant: i32 = -2;

pub const some_non_integer_constant: f32 = 0.0;
pub const another_non_integer_constant: bool = false;

pub fn main() void {
    comptime var cnt: comptime_int = 0;
    comptime var sum: comptime_int = 0;
    if (comptime builtin.zig_version.order(.{ .major = 0, .minor = 13, .patch = 0 }) == .gt) {
        inline for (@typeInfo(@This()).@"struct".decls) |decl_info| {
            const decl = @field(@This(), decl_info.name);
            switch (@typeInfo(@TypeOf(decl))) {
                .int, .comptime_int => {
                    sum += decl;
                    cnt += 1;
                },
                else => continue,
            }
        }
    } else inline for (@typeInfo(@This()).Struct.decls) |decl_info| {
        const decl = @field(@This(), decl_info.name);
        switch (@typeInfo(@TypeOf(decl))) {
            .Int, .ComptimeInt => {
                sum += decl;
                cnt += 1;
            },
            else => continue,
        }
    }

    @compileLog(std.fmt.comptimePrint("cnt = {d}, sum = {d}", .{ cnt, sum }));
}
