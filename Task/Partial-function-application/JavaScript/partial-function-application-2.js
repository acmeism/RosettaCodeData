var f1 = function (x) { return x * 2; },
    f2 = function (x) { return x * x; },

    fs = function (f) {
        return function () {
            return Array.prototype.slice.call(
                arguments
            ).map(f);
        }
    },

    fsf1 = fs(f1),
    fsf2 = fs(f2);

// Test alternative approach, with arbitrary numbers of arguments
    [
        fsf1(0, 1, 2, 3, 4),
        fsf2(0, 1, 2),
        fsf1(2, 4, 6, 8, 10, 12),
        fsf2(2, 4, 6, 8)
    ]
