const std = @import("std");

const Cuboid = struct {
    length: f64,
    breadth: f64,
    height: f64,

    pub fn init() Cuboid {
        return Cuboid{ .length = 0.0, .breadth = 0.0, .height = 0.0 };
    }

    pub fn getVolume(self: Cuboid) f64 {
        return self.length * self.breadth * self.height;
    }

    pub fn setLength(self: *Cuboid, val: f64) void {
        self.length = val;
    }

    pub fn setBreadth(self: *Cuboid, val: f64) void {
        self.breadth = val;
    }

    pub fn setHeight(self: *Cuboid, val: f64) void {
        self.height = val;
    }

    pub fn add(self: Cuboid, other: Cuboid) Cuboid {
        return Cuboid{
            .length = self.length + other.length,
            .breadth = self.breadth + other.breadth,
            .height = self.height + other.height,
        };
    }

    pub fn subtract(self: Cuboid, other: Cuboid) Cuboid {
        return Cuboid{
            .length = self.length - other.length,
            .breadth = self.breadth - other.breadth,
            .height = self.height - other.height,
        };
    }
};

pub fn main() !void {
    var c1 = Cuboid.init();
    var c2 = Cuboid.init();

    c1.setLength(6.0);
    c1.setBreadth(7.0);
    c1.setHeight(5.0);

    c2.setLength(12.0);
    c2.setBreadth(13.0);
    c2.setHeight(10.0);

    const volume = c1.getVolume();
    std.debug.print("Volume of 1st cuboid: {}\n", .{volume});

    const volume2 = c2.getVolume();
    std.debug.print("Volume of 2nd cuboid: {}\n", .{volume2});

    const c3 = c1.add(c2);
    const volume3 = c3.getVolume();
    std.debug.print("Volume of 3rd cuboid after adding: {}\n", .{volume3});

    const c4 = c1.subtract(c2);
    const volume4 = c4.getVolume();
    std.debug.print("Volume of 3rd cuboid after subtracting: {}\n", .{volume4});
}

