//! A simple implementation of the Y Combinator:
//! λf.(λx.xx)(λx.f(xx))
//! <=> λf.(λx.f(xx))(λx.f(xx))

const std = @import("std");
const debug = std.debug;
const mem = std.mem;
const Allocator = mem.Allocator;

// In Zig we can use function pointers and closures
// to implement the Y combinator without needing traits

// Generic Y combinator implementation
fn Y(comptime T: type, comptime R: type, f: fn (fn (T) R, T) R) fn (T) R {
    const Closure = struct {
        fn call(t: T) R {
            const applySelf = struct {
                fn apply(x: fn (fn (T) R, T) R, y: T) R {
                    const innerApply = struct {
                        fn inner(z: T) R {
                            return apply(x, z);
                        }
                    }.inner;
                    return x(innerApply, y);
                }
            }.apply;
            return applySelf(f, t);
        }
    };
    return Closure.call;
}

// Factorial function using Y combinator
fn fac(n: usize) usize {
    const almostFac = struct {
        fn call(f: fn (usize) usize, x: usize) usize {
            if (x == 0) return 1 else return x * f(x - 1);
        }
    }.call;

    return Y(usize, usize, almostFac)(n);
}

// Fibonacci function using Y combinator
fn fib(n: usize) usize {
    const FibTuple = struct { a0: usize, a1: usize, x: usize };

    const almostFib = struct {
        fn call(f: fn (FibTuple) usize, tuple: FibTuple) usize {
            const a0 = tuple.a0;
            const a1 = tuple.a1;
            const x = tuple.x;

            return switch (x) {
                0 => a0,
                1 => a1,
                else => f(.{ .a0 = a1, .a1 = a0 + a1, .x = x - 1 }),
            };
        }
    }.call;

    return Y(FibTuple, usize, almostFib)(.{ .a0 = 1, .a1 = 1, .x = n });
}

// Driver function
pub fn main() !void {
    const n: usize = 10;
    const stdout = std.io.getStdOut().writer();
    try stdout.print("fac({}) = {}\n", .{ n, fac(n) });
    try stdout.print("fib({}) = {}\n", .{ n, fib(n) });
}
