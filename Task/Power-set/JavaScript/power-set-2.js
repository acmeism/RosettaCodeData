(function () {

   // translating:  powerset = foldr (\x acc -> acc ++ map (x:) acc) [[]]

    function powerset(xs) {
        return xs.reduceRight(function (a, x) {
            return a.concat(a.map(function (y) {
                return [x].concat(y);
            }));
        }, [[]]);
    }


    // TEST
    return {
        '[1,2,3] ->': powerset([1, 2, 3]),
        'empty set ->': powerset([]),
        'set which contains only the empty set ->': powerset([[]])
    }

})();
