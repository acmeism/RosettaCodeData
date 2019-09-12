(() => {
    'use strict';

    const main = () =>
        showHex(
            crc32('The quick brown fox jumps over the lazy dog')
        );

    // crc32 :: String -> Int
    const crc32 = str => {

        // table :: [Int]
        const table = map(
            n => take(9,
                iterate(
                    x => (
                        x & 1 ? z => 0xEDB88320 ^ z : id
                    )(x >>> 1),
                    n
                )
            )[8],
            enumFromTo(0, 255)
        );
        return (
            foldl(
                (a, c) => (a >>> 8) ^ table[
                    (a ^ c.charCodeAt(0)) & 255
                ],
                -1,
                chars(str)
            ) ^ -1
        );
    };

    // GENERIC ABSTRACTIONS -------------------------------

    // chars :: String -> [Char]
    const chars = s => s.split('');

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // foldl :: (a -> b -> a) -> a -> [b] -> a
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // id :: a -> a
    const id = x => x;

    // iterate :: (a -> a) -> a -> Gen [a]
    function* iterate(f, x) {
        let v = x;
        while (true) {
            yield(v);
            v = f(v);
        }
    }

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // showHex :: Int -> String
    const showHex = n =>
        n.toString(16);

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = (n, xs) =>
        xs.constructor.constructor.name !== 'GeneratorFunction' ? (
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
