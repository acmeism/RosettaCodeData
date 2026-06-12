const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const PrimePower = struct {
    prime: u32,
    power: u32,

    fn init(prime: u32, power: u32) PrimePower {
        return PrimePower{
            .prime = prime,
            .power = power,
        };
    }
};

fn primePowers(allocator: Allocator, number: u32) !ArrayList(PrimePower) {
    var powers = ArrayList(PrimePower).init(allocator);
    var n = number;

    var i: u32 = 2;
    while (i * i <= n) {
        if (n % i == 0) {
            try powers.append(PrimePower.init(i, 0));
            while (n % i == 0) {
                powers.items[powers.items.len - 1].power += 1;
                n /= i;
            }
        }
        i += 1;
    }

    if (n > 1) {
        try powers.append(PrimePower.init(n, 1));
    }

    return powers;
}

fn gcd(a: u32, b: u32) u32 {
    if (b == 0) {
        return a;
    } else {
        return gcd(b, a % b);
    }
}

fn lcm(a: u32, b: u32) u32 {
    return (a / gcd(a, b)) * b;
}

fn pow(base: u32, exponent: u32) u32 {
    var result: u32 = 1;
    var exp = exponent;
    var b = base;

    while (exp > 0) {
        if (exp % 2 == 1) {
            result *= b;
        }
        b *= b;
        exp /= 2;
    }

    return result;
}

fn carmichaelLambda(allocator: Allocator, number: u32) !u32 {
    if (number == 1) {
        return 1;
    }

    var powers = try primePowers(allocator, number);
    defer powers.deinit();

    var result: u32 = 1;

    for (powers.items) |prime_power| {
        var car = (prime_power.prime - 1) * pow(prime_power.prime, prime_power.power - 1);
        if (prime_power.prime == 2 and prime_power.power >= 3) {
            car /= 2;
        }
        result = lcm(result, car);
    }

    return result;
}

fn countIterationsToOne(allocator: Allocator, n: u32) !u32 {
    if (n <= 1) {
        return 0;
    } else {
        const lambda = try carmichaelLambda(allocator, n);
        const iterations = try countIterationsToOne(allocator, lambda);
        return iterations + 1;
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    print(" n   carmichael(n) iterations(n)\n" , .{});
    print("--------------------------------\n", .{});

    var i: u32 = 1;
    while (i <= 25) : (i += 1) {
        const lambda = try carmichaelLambda(allocator, i);
        const iterations = try countIterationsToOne(allocator, i);
        print("{d:2}{d:10}{d:14}\n", .{ i, lambda, iterations });
    }

    print("\n", .{});
    print("Iterations to 1     n     lambda(n)\n", .{});
    print("-----------------------------------\n", .{});

    var n: u32 = 1;
    i = 0;
    while (i <= 15) : (i += 1) {
        while (true) {
            const iterations = try countIterationsToOne(allocator, n);
            if (iterations == i) break;
            n += 1;
        }
        const lambda = try carmichaelLambda(allocator, n);
        print("{d:2}{d:19}{d:13}\n", .{ i, n, lambda });
    }
}
