import core.stdc.stdio, std.math, std.conv, std.algorithm, std.array;

void showLookAndSay(bool showArrays)(in uint n) nothrow {
    if (n == 0) // No sequences to generate and show.
        return;

    enum Digit : char { nil = '\0', one = '1', two = '2', thr = '3' }

    // Allocate an approximate upper bound size for the array.
    static Digit* allocBuffer(in uint m) nothrow {
        immutable len = cast(size_t)(100 + 1.05 *
                                     exp(0.269 * m + 0.2686)) + 1;
        auto a = len.uninitializedArray!(Digit[]);
        printf("Allocated %d bytes.\n", a.length * Digit.sizeof);
        return a.ptr;
    }

    // Can't be expressed in the D type system:
    // a1 and a2 are immutable pointers to mutable data.
    auto a1 = allocBuffer(n % 2 ? n : n - 1);
    auto a2 = allocBuffer(n % 2 ? n - 1 : n);
    printf("\n");

    a1[0] = Digit.one;
    size_t len1 = 1;
    a1[len1] = Digit.nil;

    foreach (immutable i; 0 .. n - 1) {
        static if (showArrays)
            printf("%2u: %s\n", i + 1, a1);
        else
            printf("%2u: n. digits: %u\n", i + 1, len1);
        auto p1 = a1,
             p2 = a2;

        S0: final switch (*p1++) with (Digit) { // Initial state.
                case nil: goto END;
                case one: goto S1;
                case two: goto S2;
                case thr: goto S3;
            }
        S1: final switch (*p1++) with (Digit) {
                case nil: *p2++ = one; *p2++ = one; goto END;
                case one: goto S11;
                case two: *p2++ = one; *p2++ = one; goto S2;
                case thr: *p2++ = one; *p2++ = one; goto S3;
            }
        S2: final switch (*p1++) with (Digit) {
                case nil: *p2++ = one; *p2++ = two; goto END;
                case one: *p2++ = one; *p2++ = two; goto S1;
                case two: goto S22;
                case thr: *p2++ = one; *p2++ = two; goto S3;
            }
        S3: final switch (*p1++) with (Digit) {
                case nil: *p2++ = one; *p2++ = thr; goto END;
                case one: *p2++ = one; *p2++ = thr; goto S1;
                case two: *p2++ = one; *p2++ = thr; goto S2;
                case thr: goto S33;
            }
        S11: final switch (*p1++) with (Digit) {
                case nil: *p2++ = two; *p2++ = one; goto END;
                case one: *p2++ = thr; *p2++ = one; goto S0;
                case two: *p2++ = two; *p2++ = one; goto S2;
                case thr: *p2++ = two; *p2++ = one; goto S3;
            }
        S22: final switch (*p1++) with (Digit) {
                case nil: *p2++ = two; *p2++ = two; goto END;
                case one: *p2++ = two; *p2++ = two; goto S1;
                case two: *p2++ = thr; *p2++ = two; goto S0;
                case thr: *p2++ = two; *p2++ = two; goto S3;
            }
        S33: final switch (*p1++) with (Digit) {
                case nil: *p2++ = two; *p2++ = thr; goto END;
                case one: *p2++ = two; *p2++ = thr; goto S1;
                case two: *p2++ = two; *p2++ = thr; goto S2;
                case thr: *p2++ = thr; *p2++ = thr; goto S0;
            }
        END:
            immutable len2 = p2 - a2;
            a2[len2] = Digit.nil;
            a1.swap(a2);
            len1 = len2;
    }

    static if (showArrays)
        printf("%2u: %s\n", n, a1);
    else
        printf("%2u: n. digits: %u\n", n, len1);
}

void main(in string[] args) {
    immutable n = (args.length == 2) ? args[1].to!uint : 10;
    n.showLookAndSay!true;
}
