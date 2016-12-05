(function () {

    // permutations :: [a] -> [[a]]
    function permutations(xs) {
        return xs.length ? (concatMap(
            function (x) {
                return concatMap(
                    function (ys) {
                        return ([[x].concat(ys)]);
                    }, permutations(delete1(x, xs)))
            }, xs)) : [[]]
    }


    // GENERIC LIBRARY FUNCTIONS

    // concatMap :: (a -> [b]) -> [a] -> [b]
    function concatMap(f, xs) {
        return [].concat.apply([], xs.map(f));
    }

    // delete first instance of a in [a]
    // delete1 :: a -> [a] -> [a]
    function delete1(x, xs) {
        return deleteBy(function (a, b) {
            return a === b;
        }, x, xs);
    }

    // deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]
    function deleteBy(fnEq, x, xs) {
        return xs.length ? fnEq(x, xs[0]) ? xs.slice(1) : [xs[0]]
            .concat(deleteBy(fnEq, x, xs.slice(1))) : [];
    }


    return permutations(['Aardvarks', 'eat', 'ants'])

})();
