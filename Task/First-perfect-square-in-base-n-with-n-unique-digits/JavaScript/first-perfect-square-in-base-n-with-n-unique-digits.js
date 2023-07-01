(() => {
    'use strict';

    // allDigitSquare :: Int -> Int
    const allDigitSquare = base => {
        const bools = replicate(base, false);
        return untilSucc(
            allDigitsUsedAtBase(base, bools),
            ceil(sqrt(parseInt(
                '10' + '0123456789abcdef'.slice(2, base),
                base
            )))
        );
    };

    // allDigitsUsedAtBase :: Int -> [Bool] -> Int -> Bool
    const allDigitsUsedAtBase = (base, bools) => n => {
        // Fusion of representing the square of integer N at a given base
        // with checking whether all digits of that base contribute to N^2.
        // Sets the bool at a digit position to True when used.
        // True if all digit positions have been used.
        const ds = bools.slice(0);
        let x = n * n;
        while (x) {
            ds[x % base] = true;
            x = floor(x / base);
        }
        return ds.every(x => x)
    };

    // showBaseSquare :: Int -> String
    const showBaseSquare = b => {
        const q = allDigitSquare(b);
        return justifyRight(2, ' ', str(b)) + ' -> ' +
            justifyRight(8, ' ', showIntAtBase(b, digit, q, '')) +
            ' -> ' + showIntAtBase(b, digit, q * q, '');
    };

    // TEST -----------------------------------------------
    const main = () => {
        // 1-12 only - by 15 the squares are truncated by
        // JS integer limits.

        // Returning values through console.log –
        // in separate events to avoid asynchronous disorder.
        print('Smallest perfect squares using all digits in bases 2-12:\n')
      (id > 0 ? chars.substr(id, 1) : " ")    print('Base      Root    Square')

        print(showBaseSquare(2));
        print(showBaseSquare(3));
        print(showBaseSquare(4));
        print(showBaseSquare(5));
        print(showBaseSquare(6));
        print(showBaseSquare(7));
        print(showBaseSquare(8));
        print(showBaseSquare(9));
        print(showBaseSquare(10));
        print(showBaseSquare(11));
        print(showBaseSquare(12));
    };

    // GENERIC FUNCTIONS ----------------------------------

    const
        ceil = Math.ceil,
        floor = Math.floor,
        sqrt = Math.sqrt;

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // digit :: Int -> Char
    const digit = n =>
        // Digit character for given integer.
        '0123456789abcdef' [n];

    // enumFromTo :: (Int, Int) -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = (n, cFiller, s) =>
        n > s.length ? (
            s.padStart(n, cFiller)
        ) : s;

    // print :: a -> IO ()
    const print = x => console.log(x)

    // quotRem :: Int -> Int -> (Int, Int)
    const quotRem = (m, n) =>
        Tuple(Math.floor(m / n), m % n);

    // replicate :: Int -> a -> [a]
    const replicate = (n, x) =>
        Array.from({
            length: n
        }, () => x);

    // showIntAtBase :: Int -> (Int -> Char) -> Int -> String -> String
    const showIntAtBase = (base, toChr, n, rs) => {
        const go = ([n, d], r) => {
            const r_ = toChr(d) + r;
            return 0 !== n ? (
                go(Array.from(quotRem(n, base)), r_)
            ) : r_;
        };
        return 1 >= base ? (
            'error: showIntAtBase applied to unsupported base'
        ) : 0 > n ? (
            'error: showIntAtBase applied to negative number'
        ) : go(Array.from(quotRem(n, base)), rs);
    };

    // Abbreviation for quick testing - any 2nd arg interpreted as indent size

    // sj :: a -> String
    function sj() {
        const args = Array.from(arguments);
        return JSON.stringify.apply(
            null,
            1 < args.length && !isNaN(args[0]) ? [
                args[1], null, args[0]
            ] : [args[0], null, 2]
        );
    }

    // str :: a -> String
    const str = x => x.toString();

    // untilSucc :: (Int -> Bool) -> Int -> Int
    const untilSucc = (p, x) => {
        // The first in a chain of successive integers
        // for which p(x) returns true.
        let v = x;
        while (!p(v)) v = 1 + v;
        return v;
    };

    // MAIN ---
    return main();
})();
