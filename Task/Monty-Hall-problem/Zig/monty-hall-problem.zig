const std = @import("std");

const number_of_simulations: u32 = 10_000_000;

pub fn main() !void {
    var stick_wins: u32 = 0;
    var switch_wins: u32 = 0;
    var doors = [3]bool{ true, false, false };

    var t = std.rand.DefaultPrng.init(42);
    const r = t.random();

    var guess: u8 = undefined;
    var door_shown: u8 = undefined;

    for (0..number_of_simulations) |_| {
        std.rand.Random.shuffle(r, bool, &doors);
        guess = r.intRangeAtMost(u8, 0, 2);
        door_shown = r.intRangeAtMost(u8, 0, 2);
        while (!doors[door_shown] and door_shown != guess) door_shown = r.intRangeAtMost(u8, 0, 2);
        if (doors[guess]) {
            stick_wins += 1;
        } else {
            switch_wins += 1;
        }
    }

    std.debug.print("After {} simulations:\nStick wins: {}\nSwitch wins: {}\n", .{ number_of_simulations, stick_wins, switch_wins });
}
