const std = @import("std");

pub fn main() anyerror!void {
    var l1 = LinkedList(i32).init();

    try l1.add(1);
    try l1.add(2);
    try l1.add(4);
    try l1.add(3);

    var h = l1.head;

    while (h) |head| : (h = head.next) {
        std.log.info("> {}", .{ head.value });
    }
}
