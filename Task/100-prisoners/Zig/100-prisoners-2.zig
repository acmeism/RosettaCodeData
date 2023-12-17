const std = @import("std");

pub fn main() std.os.GetRandomError!void {
    var prnd = std.rand.DefaultPrng.init(seed: {
        var init_seed: u64 = undefined;
        try std.os.getrandom(std.mem.asBytes(&init_seed));
        break :seed init_seed;
    });
    const random = prnd.random();

    var cupboard = Cupboard.init(random);

    cupboard.runSimulation(.follow_card, 10_000);
    cupboard.runSimulation(.random, 10_000);
}
