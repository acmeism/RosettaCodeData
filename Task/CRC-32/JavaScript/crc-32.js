(() => {
    'use strict';

    // --------------------- CRC-32 ----------------------

    // crc32 :: String -> Int
    const crc32 = str => {
        // table :: [Int]
        const table = enumFromTo(0)(255).map(
            n => take(9)(
                iterate(
                    x => (
                        x & 1 ? (
                            z => 0xEDB88320 ^ z
                        ) : identity
                    )(x >>> 1)
                )(n)
            )[8]
        );
        return chars(str).reduce(
            (a, c) => (a >>> 8) ^ table[
                (a ^ c.charCodeAt(0)) & 255
            ],
            -1
        ) ^ -1;
    };

    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        showHex(
            crc32('The quick brown fox jumps over the lazy dog')
        );

    // --------------------- GENERIC ---------------------

    // chars :: String -> [Char]
    const chars = s =>
        s.split('');


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => !isNaN(m) ? (
            Array.from({
                length: 1 + n - m
            }, (_, i) => m + i)
        ) : enumFromTo_(m)(n);


    // identity :: a -> a
    const identity = x =>
        // The identity function.
        x;


    // iterate :: (a -> a) -> a -> Gen [a]
    const iterate = f =>
        // An infinite list of repeated
        // applications of f to x.
        function* (x) {
            let v = x;
            while (true) {
                yield(v);
                v = f(v);
            }
        };


    // showHex :: Int -> String
    const showHex = n =>
        // Hexadecimal string for a given integer.
        '0x' + n.toString(16);


    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n =>
        // The first n elements of a list,
        // string of characters, or stream.
        xs => 'GeneratorFunction' !== xs
        .constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));


    // MAIN -------------
    const result = main();
    return (
        console.log(result),
        result
    );
})();
