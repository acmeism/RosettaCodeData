/// Prime sieve based on: http://www.cs.hmc.edu/~oneill/papers/Sieve-JFP.pdf

import std.container: Array, BinaryHeap, RedBlackTree;

struct LazyPrimeSieve {
    @property bool empty() const pure nothrow @safe @nogc {
        return i > 203_280_221; // Pi(2 ^^ 32).
    }

    @property auto front() const pure nothrow @safe @nogc {
        return prime;
    }

    @property void popFront() pure nothrow /*@safe*/ {
        prime = sieveOne();
    }

private:
    static struct Wheel2357 {
        static immutable ubyte[48] holes = [2, 4, 2, 4, 6, 2, 6, 4, 2, 4, 6, 6,
            2, 6, 4, 2, 6, 4, 6, 8, 4, 2, 4, 2, 4, 8, 6, 4, 6, 2, 4, 6, 2, 6, 6,
            4, 2, 4, 6, 2, 6, 4, 2, 4, 2, 10, 2, 10];
        static immutable ubyte[4] spokes = [2, 3, 5, 7];
        static immutable ubyte first = 11;
        uint i;

        auto spin() pure nothrow @safe @nogc {
            return holes[i++ % $];
        }
    }

    static struct CompositeIterator {
        uint prime;
        Wheel2357 wheel;
        ulong composite;

        this(uint p) pure nothrow @safe @nogc {
            prime = p;
            composite = p * wheel.first;
        }

        void next() pure nothrow @safe @nogc {
            composite += prime * wheel.spin;
        }
    }

    version (heap)  // Less memory but slower.
        BinaryHeap!(Array!CompositeIterator, "a.composite > b.composite") iterators;
    else            // Faster but is more GC intensive.
        RedBlackTree!(CompositeIterator, "a.composite < b.composite", true) iterators;

    uint prime = 2;
    uint i = 1;
    Wheel2357 wheel;
    uint candidate = wheel.first;

    uint sieveOne() pure nothrow /*@safe*/ {
        switch (i) {
            case 0: .. case wheel.spokes.length - 1:
                return wheel.spokes[i++];

            case wheel.spokes.length:
                i++;
                return candidate;

            case wheel.spokes.length + 1:
                version (heap) {}
                else
                    iterators = new typeof(iterators);
                goto default;

            default:
                goto POST_RETURN;

                while (true) {
                    candidate += wheel.spin;

                    while (iterators.front.composite < candidate) {
                        auto it = iterators.front;
                        iterators.removeFront;
                        it.next;
                        iterators.insert(it);
                    }

                    if (iterators.front.composite != candidate) {
                        i++;
                        return candidate;
        POST_RETURN:
                        // Only insert primes that are multiply
                        // occuring in [0, 2 ^^ 32).
                        if (candidate < 2 ^^ 16)
                            iterators.insert(CompositeIterator(candidate));
                    }
                }
        }
    }
}


void main() /*@safe*/ {
    import std.stdio, std.algorithm, std.range;

    writeln("Sum of first 100,000 primes: ", LazyPrimeSieve().take(100_000).sum(0uL));

    writeln("First twenty primes:\n", LazyPrimeSieve().take(20));
    writeln("Primes primes between 100 and 150:\n",
            LazyPrimeSieve().until!q{a > 150}.filter!q{a > 99});
    writeln("Number of primes between 7,700 and 8,000: ",
            LazyPrimeSieve().until!q{a > 8_000}.filter!q{a > 7_699}.walkLength);
    writeln("10,000th prime: ", LazyPrimeSieve().dropExactly(9999).front);
}
