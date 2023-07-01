const std = @import("std");
const fs = std.fs;

pub fn main() !void {
    const here = fs.cwd();
    try here.deleteFile("input.txt");
    try here.deleteDir("docs");

    const root = try fs.openDirAbsolute("/", .{});
    try root.deleteFile("input.txt");
    try root.deleteDir("docs");
}
