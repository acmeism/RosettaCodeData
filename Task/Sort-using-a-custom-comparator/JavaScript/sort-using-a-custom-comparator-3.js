(() => {
    'use strict';

    // GENERIC FUNCTIONS FOR COMPARISONS

    // Ordering :: ( LT | EQ | GT ) | ( -1 | 0 | 1 )
    // compare :: a -> a -> Ordering
    const compare = (a, b) => a < b ? -1 : (a > b ? 1 : 0);

    // mappendOrdering :: Ordering -> Ordering -> Ordering
    const mappendOrdering = (a, b) => a !== 0 ? a : b;

    // on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
    const on = (f, g) => (a, b) => f(g(a), g(b));

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f => (a, b) => f.apply(null, [b, a]);

    // arrayCopy :: [a] -> [a]
    const arrayCopy = (xs) => xs.slice(0);

    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);


    // TEST
    const xs = ['Shanghai', 'Karachi', 'Beijing', 'Sao Paulo', 'Dhaka', 'Delhi', 'Lagos'];

    const rs = [{
        name: 'Shanghai',
        pop: 24.2
    }, {
        name: 'Karachi',
        pop: 23.5
    }, {
        name: 'Beijing',
        pop: 21.5
    }, {
        name: 'Sao Paulo',
        pop: 24.2
    }, {
        name: 'Dhaka',
        pop: 17.0
    }, {
        name: 'Delhi',
        pop: 16.8
    }, {
        name: 'Lagos',
        pop: 16.1
    }]

    // population :: Dictionary -> Num
    const population = x => x.pop;

    // length :: [a] -> Int
    const length = xs => xs.length;

    // toLower :: String -> String
    const toLower = s => s.toLowerCase();

    // lengthThenAZ :: String -> String -> ( -1 | 0 | 1)
    const lengthThenAZ = (a, b) =>
        mappendOrdering(
            on(compare, length)(a, b),
            on(compare, toLower)(a, b)
        );

    // descLengthThenAZ :: String -> String -> ( -1 | 0 | 1)
    const descLengthThenAZ = (a, b) =>
        mappendOrdering(
            on(flip(compare), length)(a, b),
            on(compare, toLower)(a, b)
        );

    return show({
        default: arrayCopy(xs)
            .sort(compare),

        descendingDefault: arrayCopy(xs)
            .sort(flip(compare)),

        byLengthThenAZ: arrayCopy(xs)
            .sort(lengthThenAZ),

        byDescendingLengthThenZA: arrayCopy(xs)
            .sort(flip(lengthThenAZ)),

        byDescendingLengthThenAZ: arrayCopy(xs)
            .sort(descLengthThenAZ),

        byPopulation: arrayCopy(rs)
            .sort(on(compare, population)),

        byDescendingPopulation: arrayCopy(rs)
            .sort(on(flip(compare), population))
    });
})();
