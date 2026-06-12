const std = @import("std");
const math = std.math;
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const Random = std.Random;

const EPSILON: f64 = 0.001;

fn doubleEquals(a: f64, b: f64) bool {
    return @abs(a - b) < EPSILON;
}

fn vectorEqualsF64(lhs: []const f64, rhs: []const f64) bool {
    if (lhs.len != rhs.len) return false;
    for (lhs, rhs) |a, b| {
        if (!doubleEquals(a, b)) return false;
    }
    return true;
}

fn vectorEquals2D(lhs: []const []const f64, rhs: []const []const f64) bool {
    if (lhs.len != rhs.len) return false;
    for (lhs, rhs) |a, b| {
        if (!vectorEqualsF64(a, b)) return false;
    }
    return true;
}

const Parameters = struct {
    omega: f64,
    phip: f64,
    phig: f64,

    fn equals(self: Parameters, other: Parameters) bool {
        return doubleEquals(self.omega, other.omega) and
            doubleEquals(self.phip, other.phip) and
            doubleEquals(self.phig, other.phig);
    }
};

const State = struct {
    iter: i32,
    gbpos: []f64,
    gbval: f64,
    min: []f64,
    max: []f64,
    parameters: Parameters,
    pos: [][]f64,
    vel: [][]f64,
    bpos: [][]f64,
    bval: []f64,
    n_particles: usize,
    n_dims: usize,
    allocator: Allocator,

    fn init(allocator: Allocator, min: []const f64, max: []const f64, parameters: Parameters, n_particles: usize) !State {
        const n_dims = min.len;

        // Allocate memory for all arrays
        const gbpos = try allocator.alloc(f64, n_dims);
        const min_copy = try allocator.alloc(f64, n_dims);
        const max_copy = try allocator.alloc(f64, n_dims);
        const pos = try allocator.alloc([]f64, n_particles);
        const vel = try allocator.alloc([]f64, n_particles);
        const bpos = try allocator.alloc([]f64, n_particles);
        const bval = try allocator.alloc(f64, n_particles);

        // Initialize arrays
        for (gbpos) |*val| val.* = math.inf(f64);
        @memcpy(min_copy, min);
        @memcpy(max_copy, max);

        for (0..n_particles) |i| {
            pos[i] = try allocator.alloc(f64, n_dims);
            vel[i] = try allocator.alloc(f64, n_dims);
            bpos[i] = try allocator.alloc(f64, n_dims);

            @memcpy(pos[i], min);
            @memset(vel[i], 0.0);
            @memcpy(bpos[i], min);
            bval[i] = math.inf(f64);
        }

        return State{
            .iter = 0,
            .gbpos = gbpos,
            .gbval = math.inf(f64),
            .min = min_copy,
            .max = max_copy,
            .parameters = parameters,
            .pos = pos,
            .vel = vel,
            .bpos = bpos,
            .bval = bval,
            .n_particles = n_particles,
            .n_dims = n_dims,
            .allocator = allocator,
        };
    }

    fn deinit(self: *State) void {
        self.allocator.free(self.gbpos);
        self.allocator.free(self.min);
        self.allocator.free(self.max);
        self.allocator.free(self.bval);

        for (self.pos) |p| self.allocator.free(p);
        for (self.vel) |v| self.allocator.free(v);
        for (self.bpos) |bp| self.allocator.free(bp);

        self.allocator.free(self.pos);
        self.allocator.free(self.vel);
        self.allocator.free(self.bpos);
    }

    fn clone(self: *const State) !State {
        var new_state = try State.init(self.allocator, self.min, self.max, self.parameters, self.n_particles);

        new_state.iter = self.iter;
        @memcpy(new_state.gbpos, self.gbpos);
        new_state.gbval = self.gbval;
        @memcpy(new_state.bval, self.bval);

        for (0..self.n_particles) |i| {
            @memcpy(new_state.pos[i], self.pos[i]);
            @memcpy(new_state.vel[i], self.vel[i]);
            @memcpy(new_state.bpos[i], self.bpos[i]);
        }

        return new_state;
    }

    fn equals(self: *const State, other: *const State) bool {
        return self.iter == other.iter and
            vectorEqualsF64(self.gbpos, other.gbpos) and
            doubleEquals(self.gbval, other.gbval) and
            vectorEqualsF64(self.min, other.min) and
            vectorEqualsF64(self.max, other.max) and
            self.parameters.equals(other.parameters) and
            vectorEquals2D(self.pos, other.pos) and
            vectorEquals2D(self.vel, other.vel) and
            vectorEquals2D(self.bpos, other.bpos) and
            vectorEqualsF64(self.bval, other.bval) and
            self.n_particles == other.n_particles and
            self.n_dims == other.n_dims;
    }

    fn report(self: *const State, test_func: []const u8) void {
        print("Test Function        : {s}\n", .{test_func});
        print("Iterations           : {d}\n", .{self.iter});
        print("Global Best Position : [" , .{});
        for (self.gbpos, 0..) |val, i| {
            if (i > 0) print(", ", .{});
            print("{d:.5}", .{val});
        }
        print("]\n", .{});
        print("Global Best Value    : {d}\n", .{self.gbval});
    }
};

fn pso(func: fn([]const f64) f64, state: *const State, rng: *Random) !State {
    const p = &state.parameters;

    var v = try state.allocator.alloc(f64, state.n_particles);
    defer state.allocator.free(v);

    var bpos = try state.allocator.alloc([]f64, state.n_particles);
    defer {
        for (bpos) |bp| state.allocator.free(bp);
        state.allocator.free(bpos);
    }

    var bval = try state.allocator.alloc(f64, state.n_particles);
    defer state.allocator.free(bval);

    const gbpos = try state.allocator.alloc(f64, state.n_dims);
    defer state.allocator.free(gbpos);

    var gbval: f64 = math.inf(f64);

    // Initialize arrays
    for (0..state.n_particles) |i| {
        bpos[i] = try state.allocator.alloc(f64, state.n_dims);
        @memcpy(bpos[i], state.min);
    }
    @memset(bval, 0.0);
    @memset(gbpos, 0.0);

    // Evaluate and update best positions
    for (0..state.n_particles) |j| {
        v[j] = func(state.pos[j]);

        if (v[j] < state.bval[j]) {
            @memcpy(bpos[j], state.pos[j]);
            bval[j] = v[j];
        } else {
            @memcpy(bpos[j], state.bpos[j]);
            bval[j] = state.bval[j];
        }

        if (bval[j] < gbval) {
            gbval = bval[j];
            @memcpy(gbpos, bpos[j]);
        }
    }

    const rg = rng.float(f64);

    var pos = try state.allocator.alloc([]f64, state.n_particles);
    var vel = try state.allocator.alloc([]f64, state.n_particles);

    for (0..state.n_particles) |i| {
        pos[i] = try state.allocator.alloc(f64, state.n_dims);
        vel[i] = try state.allocator.alloc(f64, state.n_dims);
        @memset(pos[i], 0.0);
        @memset(vel[i], 0.0);
    }

    // Update particle positions and velocities
    for (0..state.n_particles) |j| {
        const rp = rng.float(f64);
        var ok = true;

        for (0..state.n_dims) |k| {
            vel[j][k] = p.omega * state.vel[j][k] +
                p.phip * rp * (bpos[j][k] - state.pos[j][k]) +
                p.phig * rg * (gbpos[k] - state.pos[j][k]);

            pos[j][k] = state.pos[j][k] + vel[j][k];

            ok = ok and state.min[k] < pos[j][k] and state.max[k] > pos[j][k];
        }

        if (!ok) {
            for (0..state.n_dims) |k| {
                pos[j][k] = state.min[k] + (state.max[k] - state.min[k]) * rng.float(f64);
            }
        }
    }

    // Create new state
    var new_state = State{
        .iter = state.iter + 1,
        .gbpos = try state.allocator.alloc(f64, state.n_dims),
        .gbval = gbval,
        .min = try state.allocator.alloc(f64, state.n_dims),
        .max = try state.allocator.alloc(f64, state.n_dims),
        .parameters = state.parameters,
        .pos = pos,
        .vel = vel,
        .bpos = try state.allocator.alloc([]f64, state.n_particles),
        .bval = try state.allocator.alloc(f64, state.n_particles),
        .n_particles = state.n_particles,
        .n_dims = state.n_dims,
        .allocator = state.allocator,
    };

    @memcpy(new_state.gbpos, gbpos);
    @memcpy(new_state.min, state.min);
    @memcpy(new_state.max, state.max);
    @memcpy(new_state.bval, bval);

    for (0..state.n_particles) |i| {
        new_state.bpos[i] = try state.allocator.alloc(f64, state.n_dims);
        @memcpy(new_state.bpos[i], bpos[i]);
    }

    return new_state;
}

fn iterate(func: fn([]const f64) f64, n: ?i32, state: *State, rng: *Random) !State {
    var result = try state.clone();

    if (n) |iterations| {
        for (0..@intCast(iterations)) |_| {
            var old_result = result;
            result = try pso(func, &result, rng);
            old_result.deinit();
        }
    } else {
        // Iterate until convergence
        while (true) {
            var old = try result.clone();
            const new_result = try pso(func, &result, rng);
            result.deinit();
            result = new_result;

            if (result.equals(&old)) {
                old.deinit();
                break;
            }
            old.deinit();
        }
    }

    return result;
}

fn mccormick(x: []const f64) f64 {
    const a = x[0];
    const b = x[1];
    return math.sin(a + b) + math.pow(f64, a - b, 2.0) + 1.0 + 2.5 * b - 1.5 * a;
}

fn michalewicz(x: []const f64) f64 {
    const m = 10;
    const d = x.len;
    var sum: f64 = 0.0;

    for (1..d) |i| {
        const j = x[i - 1];
        const k = math.sin(@as(f64, @floatFromInt(i)) * j * j / math.pi);
        sum += math.sin(j) * math.pow(f64, k, 2.0 * @as(f64, @floatFromInt(m)));
    }

    return -sum;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var prng = std.Random.DefaultPrng.init(@as(u64, @intCast(std.time.milliTimestamp())));
    var rng = prng.random();

    // Test McCormick function
    var state = try State.init(
        allocator,
        &[_]f64{ -1.5, -3.0 },
        &[_]f64{ 4.0, 4.0 },
        Parameters{
            .omega = 0.0,
            .phip = 0.6,
            .phig = 0.3,
        },
        100,
    );

    var result1 = try iterate(mccormick, 40, &state, &rng);
    state.deinit();

    result1.report("McCormick");
    print("f(-0.54719, -1.54719) : {d}\n", .{mccormick(&[_]f64{ -0.54719, -1.54719 })});
    print("\n", .{});

    result1.deinit();

    // Test Michalewicz function
    var state2 = try State.init(
        allocator,
        &[_]f64{ 0.0, 0.0 },
        &[_]f64{ math.pi, math.pi },
        Parameters{
            .omega = 0.3,
            .phip = 0.3,
            .phig = 0.3,
        },
        1000,
    );

    var result2 = try iterate(michalewicz, 30, &state2, &rng);
    state2.deinit();

    result2.report("Michalewicz (2D)");
    print("f(2.20, 1.57)        : {d}\n", .{michalewicz(&[_]f64{ 2.2, 1.57 })});

    result2.deinit();
}
