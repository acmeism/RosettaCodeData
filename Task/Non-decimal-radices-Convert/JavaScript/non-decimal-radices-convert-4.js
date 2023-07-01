(() => {
    'use strict';

    // toBase :: Int -> Int -> String
    const toBase = (intBase, n) =>
        intBase < 36 && intBase > 0 ?
        inBaseDigits('0123456789abcdef'.substr(0, intBase), n) : [];


    // inBaseDigits :: String -> Int -> [String]
    const inBaseDigits = (digits, n) => {
        const intBase = digits.length;

        return unfoldr(maybeResidue => {
                const [divided, remainder] = quotRem(maybeResidue.new, intBase);

                return {
                    valid: divided > 0,
                    value: digits[remainder],
                    new: divided
                };
            }, n)
            .reverse()
            .join('');
    };


    // GENERIC FUNCTIONS

    // unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
    const unfoldr = (mf, v) => {
        var xs = [];
        return (until(
            m => !m.valid,
            m => {
                const m2 = mf(m);
                return (
                    xs = xs.concat(m2.value),
                    m2
                );
            }, {
                valid: true,
                value: v,
                new: v,
            }
        ), xs);
    };

    // curry :: ((a, b) -> c) -> a -> b -> c
    const curry = f => a => b => f(a, b);

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    }

    // quotRem :: Integral a => a -> a -> (a, a)
    const quotRem = (m, n) => [Math.floor(m / n), m % n];

    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);


    // OTHER FUNCTIONS DERIVABLE FROM inBaseDigits

    // inLowerHex :: Int -> String
    const inLowerHex = curry(inBaseDigits)('0123456789abcdef');

    /// inUpperHex :: Int -> String
    const inUpperHex = curry(inBaseDigits)('0123456789ABCDEF');

    // inOctal :: Int -> String
    const inOctal = curry(inBaseDigits)('01234567');

    // inDevanagariDecimal :: Int -> String
    const inDevanagariDecimal = curry(inBaseDigits)('०१२३४५६७८९');


    // TESTS
    // testNumber :: [Int]
    const testNumbers = [255, 240];

    return testNumbers.map(n => show({
        binary: toBase(2, n),
        base5: toBase(5, n),
        hex: toBase(16, n),
        upperHex: inUpperHex(n),
        octal: inOctal(n),
        devanagariDecimal: inDevanagariDecimal(n)
    }));
})();
