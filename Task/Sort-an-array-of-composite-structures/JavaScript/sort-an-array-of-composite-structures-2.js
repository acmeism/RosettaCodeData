(() => {
    'use strict';

    // GENERIC FUNCTIONS FOR COMPARISONS

    // compare :: a -> a -> Ordering
    const compare = (a, b) => a < b ? -1 : (a > b ? 1 : 0);

    // on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
    const on = (f, g) => (a, b) => f(g(a), g(b));

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f => (a, b) => f.apply(null, [b, a]);

    // arrayCopy :: [a] -> [a]
    const arrayCopy = (xs) => xs.slice(0);

    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);


    // TEST
    const xs = [{
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

    // name :: Dictionary -> String
    const name = x => x.name;

    return show({
        byPopulation: arrayCopy(xs)
            .sort(on(compare, population)),
        byDescendingPopulation: arrayCopy(xs)
            .sort(on(flip(compare), population)),
        byName: arrayCopy(xs)
            .sort(on(compare, name)),
        byDescendingName: arrayCopy(xs)
            .sort(on(flip(compare), name))
    });
})();
