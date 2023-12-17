const std = @import("std");

pub const first_integer_constant: i32 = 5;
pub const second_integer_constant: i32 = 3;
pub const third_integer_constant: i32 = -2;

pub const some_non_integer_constant: f32 = 0.0;
pub const another_non_integer_constant: bool = false;

pub fn main() void {
    comptime var cnt: comptime_int = 0;
    comptime var sum: comptime_int = 0;
    inline for (@typeInfo(@This()).Struct.decls) |decl_info| {
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
