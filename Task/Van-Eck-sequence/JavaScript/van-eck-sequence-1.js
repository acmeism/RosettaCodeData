(() => {
    'use strict';

    // vanEck :: Int -> [Int]
    const vanEck = n =>
        reverse(
            churchNumeral(n)(
                xs => 0 < xs.length ? cons(
                    maybe(
                        0, succ,
                        elemIndex(xs[0], xs.slice(1))
                    ),
                    xs
                ) : [0]
            )([])
        );

    // TEST -----------------------------------------------
    const main = () => {
        console.log('VanEck series:\n')
        showLog('First 10 terms', vanEck(10))
        showLog('Terms 991-1000', vanEck(1000).slice(990))
    };

    // GENERIC FUNCTIONS ----------------------------------

    // Just :: a -> Maybe a
    const Just = x => ({
        type: 'Maybe',
        Nothing: false,
        Just: x
    });

    // Nothing :: Maybe a
    const Nothing = () => ({
        type: 'Maybe',
        Nothing: true,
    });

    // churchNumeral :: Int -> (a -> a) -> a -> a
    const churchNumeral = n => f => x =>
        Array.from({
            length: n
        }, () => f)
        .reduce((a, g) => g(a), x)

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) => [x].concat(xs)

    // elemIndex :: Eq a => a -> [a] -> Maybe Int
    const elemIndex = (x, xs) => {
        const i = xs.indexOf(x);
        return -1 === i ? (
            Nothing()
        ) : Just(i);
    };

    // maybe :: b -> (a -> b) -> Maybe a -> b
    const maybe = (v, f, m) =>
        m.Nothing ? v : f(m.Just);

    // reverse :: [a] -> [a]
    const reverse = xs =>
        'string' !== typeof xs ? (
            xs.slice(0).reverse()
        ) : xs.split('').reverse().join('');

    // showLog :: a -> IO ()
    const showLog = (...args) =>
        console.log(
            args
            .map(JSON.stringify)
            .join(' -> ')
        );

    // succ :: Int -> Int
    const succ = x => 1 + x;

    // MAIN ---
    return main();
})();
