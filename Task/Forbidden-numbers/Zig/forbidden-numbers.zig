fn forbidden(n: u64) bool {
    var nn = n;
    while (nn>1 and nn & 3 == 0) nn >>= 2;
    return nn & 7 == 7;
}

fn nextForbidden(n: u64) u64 {
    var nn = n+1;
    while (!forbidden(nn)) nn += 1;
    return nn;
}

pub fn main() !void {
    const stdout = @import("std").io.getStdOut().writer();
    var n: u64 = 0;
    var count: u64 = 0;
    var lim: u64 = 500;

    while (lim <= 500_000_000) {
        n = nextForbidden(n);
        count += 1;

        if (count <= 50) {
            try stdout.print("{d: >5} ", .{n});
            if (count % 10 == 0) try stdout.writeByte('\n');
        }

        if (n >= lim) {
            try stdout.print("Forbidden numbers up to {d: >10}: {d: >10}\n",
                  .{lim, count-1});
            lim *= 10;
        }
    }
}
