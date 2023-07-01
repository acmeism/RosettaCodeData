var f1 = function (x) { return x * 2; },
    f2 = function (x) { return x * x; },

    fs = function (f, s) {
        return function (s) {
            return s.map(f);
        }
    },

    fsf1 = fs(f1),
    fsf2 = fs(f2);

// Test
    [
        fsf1([0, 1, 2, 3]),
        fsf2([0, 1, 2, 3]),
		
        fsf1([2, 4, 6, 8]),
        fsf2([2, 4, 6, 8])
    ]
