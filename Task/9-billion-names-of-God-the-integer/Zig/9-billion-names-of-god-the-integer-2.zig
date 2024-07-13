const std = @import("std");
const print = std.debug.print;
const bigint = std.math.big.int.Managed;
const eql = std.mem.eql;
const Array = std.ArrayList;
const Array1 = Array(bigint);
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

fn calc ( n:usize, p:*Array1) !void {
    for ( 1..n+1 ) |k| {
        var d:i64 = @intCast(n);
        d -= @intCast(k*(3*k - 1)/2);
        inline for ( 0..2 ) |_| {
            if ( d < 0 ) return;
	    if (k&1>0) try p.items[n].add ( &p.items[n], &p.items[@intCast(d)] )
	    else       try p.items[n].sub ( &p.items[n], &p.items[@intCast(d)] );
            d -= @intCast(k);
        }
    }
}

fn main() !void {
    const s = [_]usize{ 23, 123, 1234, 12345, 123456 };
    var p = Array1.init ( allocator );
    try p.append ( try bigint.initSet ( allocator, 1 ) );
    var i:usize=1;
    for ( s )|m|{
        while (i<=m):(i+=1){
            try p.append( try bigint.init(allocator) );
            try calc( i, &p );
        }
        print("P({d}) = {d}\n", .{m,p.items[m]} );
    }
}
