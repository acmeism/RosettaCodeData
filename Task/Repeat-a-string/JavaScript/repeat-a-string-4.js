(() => {
    'use strict';

    // repeat :: Int -> String -> String
    const repeat = (n, s) =>
        concat(replicate(n, s));


    // GENERIC FUNCTIONS ------------------------------------------------------

    // concat :: [[a]] -> [a] | [String] -> String
    const concat = xs =>
        xs.length > 0 ? (() => {
            const unit = typeof xs[0] === 'string' ? '' : [];
            return unit.concat.apply(unit, xs);
        })() : [];

    // replicate :: Int -> a -> [a]
    const replicate = (n, x) =>
        Array.from({
            length: n
        }, () => x);


    // TEST -------------------------------------------------------------------
    return repeat(5, 'ha');
})();
