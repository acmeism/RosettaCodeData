const std = @import("std");

pub const Cupboard = struct {
    comptime {
        std.debug.assert(u7 == std.math.IntFittingRange(0, 100));
    }

    pub const Drawer = packed struct(u8) {
        already_visited: bool,
        card: u7,
    };

    drawers: [100]Drawer,
    randomizer: std.rand.Random,

    /// Cupboard is not shuffled after initialization,
    /// it is shuffled during `play` execution.
    pub fn init(random: std.rand.Random) Cupboard {
        var drawers: [100]Drawer = undefined;
        for (&drawers, 0..) |*drawer, i| {
            drawer.* = .{
                .already_visited = false,
                .card = @intCast(i),
            };
        }

        return .{
            .drawers = drawers,
            .randomizer = random,
        };
    }

    pub const Decision = enum {
        pardoned,
        sentenced,
    };

    pub const Strategy = enum {
        follow_card,
        random,

        pub fn decisionOfPrisoner(strategy: Strategy, cupboard: *Cupboard, prisoner_id: u7) Decision {
            switch (strategy) {
                .random => {
                    return for (0..50) |_| {
                        // If randomly chosen drawer was already opened,
                        // throw dice again.
                        const drawer = try_throw_random: while (true) {
                            const random_i = cupboard.randomizer.uintLessThan(u7, 100);
                            const drawer = &cupboard.drawers[random_i];

                            if (!drawer.already_visited)
                                break :try_throw_random drawer;
                        };
                        std.debug.assert(!drawer.already_visited);
                        defer drawer.already_visited = true;

                        if (drawer.card == prisoner_id)
                            break .pardoned;
                    } else .sentenced;
                },
                .follow_card => {
                    var drawer_i = prisoner_id;
                    return for (0..50) |_| {
                        const drawer = &cupboard.drawers[drawer_i];
                        std.debug.assert(!drawer.already_visited);
                        defer drawer.already_visited = true;

                        if (drawer.card == prisoner_id)
                            break .pardoned
                        else
                            drawer_i = drawer.card;
                    } else .sentenced;
                },
            }
        }
    };

    pub fn play(cupboard: *Cupboard, strategy: Strategy) Decision {
        cupboard.randomizer.shuffleWithIndex(Drawer, &cupboard.drawers, u7);

        // Decisions for all 100 prisoners.
        var all_decisions: [100]Decision = undefined;
        for (&all_decisions, 0..) |*current_decision, prisoner_id| {
            // Make decision for current prisoner
            current_decision.* = strategy.decisionOfPrisoner(cupboard, @intCast(prisoner_id));

            // Close all drawers after one step.
            for (&cupboard.drawers) |*drawer|
                drawer.already_visited = false;
        }

        // If there is at least one sentenced person, everyone are sentenced.
        return for (all_decisions) |decision| {
            if (decision == .sentenced)
                break .sentenced;
        } else .pardoned;
    }

    pub fn runSimulation(cupboard: *Cupboard, strategy: Cupboard.Strategy, total: u32) void {
        var success: u32 = 0;
        for (0..total) |_| {
            const result = cupboard.play(strategy);
            if (result == .pardoned) success += 1;
        }

        const ratio = @as(f32, @floatFromInt(success)) / @as(f32, @floatFromInt(total));

        const stdout = std.io.getStdOut();
        const stdout_w = stdout.writer();

        stdout_w.print(
            \\
            \\Strategy: {s}
            \\Total runs: {d}
            \\Successful runs: {d}
            \\Failed runs: {d}
            \\Success rate: {d:.4}%.
            \\
        , .{
            @tagName(strategy),
            total,
            success,
            total - success,
            ratio * 100.0,
        }) catch {}; // Do nothing on error
    }
};
