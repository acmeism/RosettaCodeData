const std = @import("std");
const math = std.math;
const print = std.debug.print;

pub fn main() !void {
    const target = "METHINKS IT IS LIKE A WEASEL";
    const copies: usize = 100;
    const mutation_rate: u32 = 20; // 1/20 = 0.05 = 5%

    var prng = std.Random.DefaultPrng.init(@as(u64, @intCast(std.time.milliTimestamp())));
    const rng = prng.random();

    // Generate first sentence, mutating each character
    const start = try mutate(rng, target, 1, std.heap.page_allocator); // 1/1 = 1 = 100%

    print("{s}\n", .{target});
    print("{s}\n", .{start});

    _ = try evolve(rng, target, start, copies, mutation_rate, std.heap.page_allocator);
}

/// Evolution algorithm
///
/// Evolves `parent` to match `target`. Returns the number of evolutions performed.
fn evolve(
    rng: std.Random,
    target: []const u8,
    parent: []const u8,
    copies: usize,
    mutation_rate: u32,
    allocator: std.mem.Allocator,
) !usize {
    var counter: usize = 0;
    var parent_fitness: usize = target.len + 1;
    var current_parent = try allocator.dupe(u8, parent);
    defer allocator.free(current_parent);

    while (true) {
        counter += 1;

        var best_fitness: usize = std.math.maxInt(usize);
        const best_sentence = try allocator.alloc(u8, target.len);

        for (0..copies) |_| {
            // Copy and mutate a new sentence
            const sentence = try mutate(rng, current_parent, mutation_rate, allocator);
            defer allocator.free(sentence);

            // Find the fitness of the new mutation
            const current_fitness = fitness(target, sentence);

            if (current_fitness < best_fitness) {
                best_fitness = current_fitness;
                @memcpy( best_sentence, sentence);
            }
        }

        // If the best mutation of this generation is better than `parent` then "the fittest
        // survives" and the next parent becomes the best of this generation.
        if (best_fitness < parent_fitness) {
            allocator.free(current_parent);
            current_parent = best_sentence;
            parent_fitness = best_fitness;
            print("{s} : generation {} with fitness {}\n", .{ current_parent, counter, best_fitness });

            if (best_fitness == 0) {
                return counter;
            }
        } else {
            allocator.free(best_sentence);
        }
    }
}

/// Computes the fitness of a sentence against a target string, returning the number of
/// incorrect characters.
fn fitness(target: []const u8, sentence: []const u8) usize {
    var count: usize = 0;
    for (sentence, 0..) |c, i| {
        if (c != target[i]) {
            count += 1;
        }
    }
    return count;
}

/// Mutation algorithm.
///
/// It mutates each character of a string, according to a `mutation_rate`.
fn mutate(
    rng: std.Random,
    sentence: []const u8,
    mutation_rate: u32,
    allocator: std.mem.Allocator,
) ![]u8 {
    var result = try allocator.alloc(u8, sentence.len);

    for (sentence, 0..) |c, i| {
        if (rng.int(u32) % mutation_rate == 0) {
            result[i] = randomChar(rng);
        } else {
            result[i] = c;
        }
    }

    return result;
}

/// Generates a random letter or space.
fn randomChar(rng: std.Random) u8 {
    // Returns a value in the range [A, Z] + an extra slot for the space character.
    const c = rng.intRangeAtMost(u8, 'A', 'Z' + 1);
    return if (c == 'Z' + 1) ' ' else c;
}
