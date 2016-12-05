(function (lst) {
    'use strict';

    const permutations = (xs) => xs.length ? (
            flatMap((x) => flatMap((xs) => [[x].concat(xs)],
                permutations(del(x, xs))), xs)
        ) : [[]],

        flatMap = (f, xs) => [].concat.apply([], xs.map(f)),

        del = (x, xs) => xs.length ? x === xs[0] ? (
            xs.slice(1)
        ) : [xs[0]].concat(del(x, xs.slice(1))
        ) : [];


    return permutations(lst);

})(["Aardvarks", "eat", "ants"]);
