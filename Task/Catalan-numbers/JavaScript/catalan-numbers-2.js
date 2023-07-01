(() => {
    "use strict";

    // ----------------- CATALAN NUMBERS -----------------

    // catalansDefinitionThree :: [Int]
    const catalansDefinitionThree = () =>
        // An infinite sequence of Catalan numbers.
        scanlGen(
            c => n => Math.floor(
                (2 * c * pred(2 * n)) / succ(n)
            )
        )(1)(
            enumFrom(1)
        );


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        take(15)(
            catalansDefinitionThree()
        );


    // --------------------- GENERIC ---------------------

    // enumFrom :: Enum a => a -> [a]
    const enumFrom = function* (n) {
        // An infinite sequence of integers,
        // starting with n.
        let v = n;

        while (true) {
            yield v;
            v = 1 + v;
        }
    };


    // pred :: Int -> Int
    const pred = x =>
        x - 1;


    // scanlGen :: (b -> a -> b) -> b -> Gen [a] -> [b]
    const scanlGen = f =>
        // The series of interim values arising
        // from a catamorphism over an infinite list.
        startValue => function* (gen) {
            let
                a = startValue,
                x = gen.next();

            yield a;
            while (!x.done) {
                a = f(a)(x.value);
                yield a;
                x = gen.next();
            }
        };


    // succ :: Int -> Int
    const succ = x =>
        1 + x;


    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n =>
        // The first n elements of a list,
        // string of characters, or stream.
        xs => Array.from({
            length: n
        }, () => {
            const x = xs.next();

            return x.done ? [] : [x.value];
        }).flat();


    // MAIN ---
    return JSON.stringify(main(), null, 2);
})();
