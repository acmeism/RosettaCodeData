(function () {

    // (a -> a -> Ordering) -> [a] -> a
    function maximumBy(f, xs) {
        return xs.reduce(function (a, x) {
            return a === undefined ? x : (
                f(x, a) > 0 ? x : a
            );
        }, undefined);
    }

    // COMPARISON FUNCTIONS FOR SPECIFIC DATA TYPES

    //Ordering: (LT|EQ|GT)
    //  GT: 1 (or other positive n)
    //  EQ: 0
    //  LT: -1 (or other negative n)

    function wordSortFirst(a, b) {
        return a < b ? 1 : (a > b ? -1 : 0)
    }

    function wordSortLast(a, b) {
        return a < b ? -1 : (a > b ? 1 : 0)
    }

    function wordLongest(a, b) {
        return a.length - b.length;
    }

    function cityPopulationMost(a, b) {
        return a.population - b.population;
    }

    function cityPopulationLeast(a, b) {
        return b.population - a.population;
    }

    function cityNameSortFirst(a, b) {
        var strA = a.name,
            strB = b.name;

        return strA < strB ? 1 : (strA > strB ? -1 : 0);
    }

    function cityNameSortLast(a, b) {
        var strA = a.name,
            strB = b.name;

        return strA < strB ? -1 : (strA > strB ? 1 : 0);
    }

    var lstWords = [
            'alpha', 'beta', 'gamma', 'delta', 'epsilon', 'zeta', 'eta',
            'theta', 'iota', 'kappa', 'lambda'
        ];

    var lstCities = [
        {
            name: 'Shanghai',
            population: 24.15
            }, {
            name: 'Karachi',
            population: 23.5
            }, {
            name: 'Beijing',
            population: 21.5
            }, {
            name: 'Tianjin',
            population: 14.7
            }, {
            name: 'Istanbul',
            population: 14.4
            }, , {
            name: 'Lagos',
            population: 13.4
            }, , {
            name: 'Tokyo',
            population: 13.3
            }
        ];

    return [
        maximumBy(wordSortFirst, lstWords),
        maximumBy(wordSortLast, lstWords),
        maximumBy(wordLongest, lstWords),
        maximumBy(cityPopulationMost, lstCities),
        maximumBy(cityPopulationLeast, lstCities),
        maximumBy(cityNameSortFirst, lstCities),
        maximumBy(cityNameSortLast, lstCities)
    ]

})();
