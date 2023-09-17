const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.writeAll("Police  Sanitation  Fire\n");
    try stdout.writeAll("------  ----------  ----\n");

    var it = SolutionIterator.init();
    while (it.next()) |solution| {
        try stdout.print(
            "  {d}         {d}         {d}\n",
            .{ solution.police, solution.sanitation, solution.fire },
        );
    }
}

/// 3 bit unsigned (u3) limits 0 <= department <= 7
const Departments = packed struct {
    police: u3,
    sanitation: u3,
    fire: u3,
};

const DepartmentsUnion = packed union {
    departments: Departments,
    together: u9,
};

const SolutionIterator = struct {
    // police is initialized to one as adding one is the first operation in next()
    // with the result .police == 2 (an even number) on the first pass.
    u: DepartmentsUnion = .{ .departments = .{ .police = 1, .sanitation = 1, .fire = 1 } },

    /// init() returns an initialised structure.
    /// Using init() is a common Zig pattern.
    fn init() SolutionIterator {
        return SolutionIterator{};
    }

    fn next(self: *SolutionIterator) ?Departments {
        if (self.u.together == 0) return null; // already completed

        while (true) {
            const ov = @addWithOverflow(self.u.together, 1);
            if (ov[1] == 1) {
                self.u.together = 0;
                return null; // overflowed, completed
            } else {
                self.u.together = ov[0];
                // None can be zero
                if (self.u.departments.police == 0) self.u.departments.police = 2; // even
                if (self.u.departments.sanitation == 0) self.u.departments.sanitation = 1;
                if (self.u.departments.fire == 0) self.u.departments.fire = 1;
                // Police must be even
                if (self.u.departments.police & 1 == 1)
                    continue;
                // No two can be the same
                if (self.u.departments.police == self.u.departments.sanitation) continue;
                if (self.u.departments.sanitation == self.u.departments.fire) continue;
                if (self.u.departments.fire == self.u.departments.police) continue;
                // Must total twelve (maximum sum 7 + 7 + 7 = 21 requires 5 bits)
                const p = @as(u5, self.u.departments.police);
                const s = @as(u5, self.u.departments.sanitation);
                const f = @as(u5, self.u.departments.fire);
                if (p + s + f != 12)
                    continue;

                return self.u.departments;
            }
        }
    }
};
