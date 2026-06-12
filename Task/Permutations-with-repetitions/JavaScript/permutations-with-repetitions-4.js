(() => {
    'use strict';

    // GENERIC FUNCTIONS

    // replicateM n act performs the action n times, gathering the results.
    // replicateM :: (Applicative m) => Int -> m a -> m [a]
    const replicateM = (n, f) => {
        const loop = x => x <= 0 ? [
            []
        ] : liftA2(cons, f, loop(x - 1));
        return loop(n);
    };

    // Lift a binary function to actions.
    // liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
    const liftA2 = (f, a, b) =>
        listApply(a.map(curry(f)), b);

    // <*>
    // listApply :: [(a -> b)] -> [a] -> [b]
    const listApply = (fs, xs) =>
        [].concat.apply([], fs.map(f =>
        [].concat.apply([], xs.map(x => [f(x)]))));

    // curry :: ((a, b) -> c) -> a -> b -> c
    const curry = f => a => b => f(a, b);

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) => [x].concat(xs);

    // show :: a -> String;
    const show = JSON.stringify;

    // TEST
    return show(
        replicateM(2, [1, 2, 3])
    );
    // -> [[1,1],[1,2],[1,3],[2,1],[2,2],[2,3],[3,1],[3,2],[3,3]]
})();
