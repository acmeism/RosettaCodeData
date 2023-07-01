(() => {
    'use strict';

    // main :: IO ()
    const main = () => {

        // clockWorkTick :: Dict -> (Dict, Char)
        const clockWorkTick = wheelMap => {
            // The new configuration of the wheels, tupled with
            // a digit found by recursive descent from a single
            // click of the first wheel.
            const click = wheels => wheelName => {
                const
                    wheel = wheels[wheelName] || ['?'],
                    v = wheel[0];
                return bool(click)(Tuple)(isDigit(v) || '?' === v)(
                    insertDict(wheelName)(
                        leftRotate(wheel)
                    )(wheels)
                )(v);
            };
            return click(wheelMap)('A');
        };

        // leftRotate ::[a] -> [a]
        const leftRotate = xs =>
            // The head of the list appended
            // to the tail of of the list.
            0 < xs.length ? (
                xs.slice(1).concat(xs[0])
            ) : [];


        // TEST -------------------------------------------
        // State of each wheel-set after 20 clicks,
        // paired with the resulting series of characters.

        const tuple = uncurry(Tuple);
        const wheelLists = [
            [tuple('A', '123')],
            [tuple('A', '1B2'), tuple('B', '34')],
            [tuple('A', '1DD'), tuple('D', '678')],
            [tuple('A', '1BC'), tuple('B', '34'), tuple('C', '5B')]
        ];

        console.log([
            'Series and state of each wheel-set after 20 clicks:\n',
            unlines(
                map(tuples => showWheels(
                    mapAccumL(
                        compose(constant, clockWorkTick)
                    )(dictFromList(tuples))(replicate(20)(''))
                ))(wheelLists)
            ),
            '\nInitial state of each wheel-set:\n',
            map(map(compose(
                JSON.stringify,
                dictFromList,
                x => [Array.from(x)]
            )))(wheelLists).join('\n')
        ].join('\n'));
    };

    // DISPLAY FORMATTING ---------------------------------

    // showWheels :: (Dict, [Char]) -> String
    const showWheels = tpl =>
        JSON.stringify(
            Array.from(secondArrow(concat)(tpl))
        );

    // GENERIC FUNCTIONS ----------------------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a => b => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // bool :: a -> a -> Bool -> a
    const bool = f => t => p =>
        p ? t : f;

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        x => fs.reduceRight((a, f) => f(a), x);

    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        0 < xs.length ? (() => {
            const unit = 'string' !== typeof xs[0] ? (
                []
            ) : '';
            return unit.concat.apply(unit, xs);
        })() : [];

    // constant :: a -> b -> a
    const constant = k => _ => k;

    // dictFromList :: [(k, v)] -> Dict
    const dictFromList = kvs =>
        Object.fromEntries(kvs);

    // secondArrow :: (a -> b) -> ((c, a) -> (c, b))
    const secondArrow = f => xy =>
        // A function over a simple value lifted
        // to a function over a tuple.
        // f (a, b) -> (a, f(b))
        Tuple(xy[0])(
            f(xy[1])
        );

    // insertDict :: String -> a -> Dict -> Dict
    const insertDict = k => v => dct =>
        Object.assign({}, dct, {
            [k]: v
        });

    // isDigit :: Char -> Bool
    const isDigit = c => {
        const n = c.codePointAt(0);
        return 48 <= n && 57 >= n;
    };

    // map :: (a -> b) -> [a] -> [b]
    const map = f => xs =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // Map-accumulation is a combination of map and a catamorphism;
    // it applies a function to each element of a list, passing an
    // accumulating parameter from left to right, and returning a final
    // value of this accumulator together with the new list.

    // mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
    const mapAccumL = f => acc => xs =>
        xs.reduce((a, x) => {
            const pair = f(a[0])(x);
            return Tuple(pair[0])(a[1].concat(pair[1]));
        }, Tuple(acc)([]));

    // replicate :: Int -> a -> [a]
    const replicate = n => x =>
        Array.from({
            length: n
        }, () => x);

    // uncurry :: (a -> b -> c) -> ((a, b) -> c)
    const uncurry = f =>
        (x, y) => f(x)(y);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // MAIN ---
    return main();
})();
