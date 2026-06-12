const std = @import("std");
const math = std.math;
const print = std.debug.print;
const Random = std.Random;

const Coord = struct { x: i32, y: i32 };
const NUM_CITIES: usize = 100;

// CityID with member functions to get position
const CityID = struct {
    v: i32,

    const Self = @This();

    fn new() Self {
        return Self{ .v = -1 };
    }

    fn fromInt(i: i32) Self {
        return Self{ .v = i };
    }

    fn fromCoord(ij: Coord) !Self {
        if (ij.x < 0 or ij.x > 9 or ij.y < 0 or ij.y > 9) {
            return error.InvalidCoordinates;
        }
        return Self{ .v = ij.x * 10 + ij.y };
    }

    fn getPos(self: Self) Coord {
        return Coord{ .x = @divFloor(self.v, 10), .y = @mod(self.v, 10) };
    }
};

// Function for distance between two cities
fn distCoords(city1: Coord, city2: Coord) f64 {
    const diffx = @as(f64, @floatFromInt(city1.x - city2.x));
    const diffy = @as(f64, @floatFromInt(city1.y - city2.y));
    return @sqrt(diffx * diffx + diffy * diffy);
}

// Function for total distance travelled
fn distCities(cities: *const [NUM_CITIES]CityID) f64 {
    var sum: f64 = 0.0;
    for (0..cities.len - 1) |i| {
        sum += distCoords(cities[i].getPos(), cities[i + 1].getPos());
    }
    sum += distCoords(cities[cities.len - 1].getPos(), cities[0].getPos());
    return sum;
}

// 8 nearest cities, id cannot be at the border and has to have 8 valid neighbors
fn getNearest(id: CityID) [8]CityID {
    const ij = id.getPos();
    const i = ij.x;
    const j = ij.y;
    return [8]CityID{
        CityID.fromCoord(Coord{ .x = i - 1, .y = j - 1 }) catch unreachable,
        CityID.fromCoord(Coord{ .x = i, .y = j - 1 }) catch unreachable,
        CityID.fromCoord(Coord{ .x = i + 1, .y = j - 1 }) catch unreachable,
        CityID.fromCoord(Coord{ .x = i - 1, .y = j }) catch unreachable,
        CityID.fromCoord(Coord{ .x = i + 1, .y = j }) catch unreachable,
        CityID.fromCoord(Coord{ .x = i - 1, .y = j + 1 }) catch unreachable,
        CityID.fromCoord(Coord{ .x = i, .y = j + 1 }) catch unreachable,
        CityID.fromCoord(Coord{ .x = i + 1, .y = j + 1 }) catch unreachable,
    };
}

// Function for formatting of results
fn getNumDigits(num: i32) usize {
    var n = num;
    var digits: usize = 1;
    while (n >= 10) {
        n = @divFloor(n, 10);
        digits += 1;
    }
    return digits;
}

// Function for shuffling of initial state
fn shuffleCities(cities: []CityID, rng: Random) void {
    var i = cities.len - 1;
    while (i > 0) : (i -= 1) {
        const j = rng.intRangeLessThanBiased(usize, 0, i + 1);
        std.mem.swap(CityID, &cities[i], &cities[j]);
    }
}

const SA = struct {
    k_t: i32,
    k_max: i32,
    s: [NUM_CITIES]CityID,
    rand_engine: Random,

    const Self = @This();

    fn new() Self {
        var s = [_]CityID{CityID.new()} ** NUM_CITIES;

        // Initialize state with integers from 0 to 99
        for (s[0..], 0..) |*city, i| {
            city.* = CityID.fromInt(@intCast(i));
        }

        var prng = std.Random.DefaultPrng.init(@as(u64, @intCast(std.time.milliTimestamp())));
        const rand_engine = prng.random();
        shuffleCities(&s, rand_engine);

        return Self{
            .k_t = 1,
            .k_max = 1_000_000,
            .s = s,
            .rand_engine = rand_engine,
        };
    }

    // Temperature
    fn temperature(self: Self, k: i32) f64 {
        return @as(f64, @floatFromInt(self.k_t)) * (1.0 - @as(f64, @floatFromInt(k)) / @as(f64, @floatFromInt(self.k_max)));
    }

    // Probability of acceptance between 0.0 and 1.0
    fn probability(self: Self, d_e: f64, t: f64) f64 {
        _ = self;
        if (d_e < 0.0) {
            return 1.0;
        } else {
            return @exp(-d_e / t);
        }
    }

    // Permutation of state through swapping of cities in travel path
    fn nextPermut(self: *Self, cities: [NUM_CITIES]CityID) [NUM_CITIES]CityID {
        var result = cities;

        const rand_city = CityID.fromCoord(Coord{
            .x = self.rand_engine.intRangeAtMost(i32, 1, 8),
            .y = self.rand_engine.intRangeAtMost(i32, 1, 8),
        }) catch unreachable;

        const neighbors = getNearest(rand_city);
        const rand_neighbor = neighbors[self.rand_engine.intRangeAtMost(usize, 0, neighbors.len - 1)];

        // Find selected city in state
        var city_pos1: usize = 0;
        var city_pos2: usize = 0;

        for (result[0..], 0..) |city, i| {
            if (city.v == rand_city.v) city_pos1 = i;
            if (city.v == rand_neighbor.v) city_pos2 = i;
        }

        // Swap city and neighbor
        std.mem.swap(CityID, &result[city_pos1], &result[city_pos2]);
        return result;
    }

    // Logging function for progress output
    fn logProgress(self: Self, k: i32, t: f64, e: f64) void {
        const nk = getNumDigits(self.k_max);
        print("k: {d:>7} | T: {d:.3} | E(s): {d:.4}\n", .{ k, t, e });
        _ = nk; // unused in this simplified version
    }

    // Logging function for final path
    fn logPath(self: Self) void {
        for (self.s[0..], 0..) |city, idx| {
            print("{d:2} -> ", .{city.v});
            if ((idx + 1) % 20 == 0) {
                print("\n", .{});
            }
        }
        print("{d:2}\n", .{self.s[0].v});
    }

    // Core simulated annealing algorithm
    fn run(self: *Self) [NUM_CITIES]CityID {
        print("kT == {d}\n", .{self.k_t});
        print("kmax == {d}\n", .{self.k_max});
        print("E(s0) == {d}\n", .{distCities(&self.s)});

        for (0..@intCast(self.k_max)) |k_usize| {
            const k: i32 = @intCast(k_usize);
            const t = self.temperature(k);
            const e1 = distCities(&self.s);
            const s_next = self.nextPermut(self.s);
            const e2 = distCities(&s_next);
            const d_e = e2 - e1; // lower is better

            // const e = e1;

            if (self.probability(d_e, t) >= self.rand_engine.float(f64)) {
                self.s = s_next;
            }

            if (@mod(k, 100000) == 0) {
                self.logProgress(k, t, e1);
            }
        }

        self.logProgress(self.k_max, 0.0, distCities(&self.s));
        print("\nFinal path:\n", .{});
        self.logPath();
        return self.s;
    }
};

pub fn main() !void {
    var sa = SA.new();
    _ = sa.run(); // Run simulated annealing and log progress and result

    print("Press Enter to exit...\n", .{});
    const stdin = std.io.getStdIn().reader();
    var buf: [256]u8 = undefined;
    _ = try stdin.readUntilDelimiterOrEof(buf[0..], '\n');
}
