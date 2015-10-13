(function () {

    // Generalised max() function
    // [a] -> (a -> n) -> a
    function max(list, fnCompare) {
        return list.reduce(function (acc, b) {
            var a = acc || b,
                lngDiff = fnCompare(a, b);

            return lngDiff ? (lngDiff > 0 ? b : a) : a;
        }, null)
    }

    // Comparison functions for specific data types

    function wordSortFirst(a, b) {
        return a === null ? b : a === b ? 0 : a < b ? -1 : 1;
    }

    function wordSortLast(a, b) {
        return a === null ? b : a === b ? 0 : a < b ? 1 : -1;
    }

    function wordLongest(a, b) {
        var lngA = a ? a.length : b.length,
            lngB = b.length;

        return lngA === lngB ? 0 : lngA > lngB ? -1 : 1;
    }

    function cityPopulationMost(a, b) {
        var nA = a ? a.population : b.population,
            nB = b.population;

        return nA === nB ? 0 : nA > nB ? -1 : 1;
    }

    function cityPopulationLeast(a, b) {
        var nA = a ? a.population : b.population,
            nB = b.population;

        return nA === nB ? 0 : nA < nB ? -1 : 1;
    }

    function cityNameSortFirst(a, b) {
        var sA = a ? a.name : b.name,
            sB = b.name;

        return sA === sB ? 0 : sA < sB ? -1 : 1;
    }

    function cityNameSortLast(a, b) {
        var sA = a ? a.name : b.name,
            sB = b.name;

        return sA === sB ? 0 : sA > sB ? -1 : 1;
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
        max(lstWords, wordSortFirst),
        max(lstWords, wordSortLast),
        max(lstWords, wordLongest),
        max(lstCities, cityPopulationMost),
        max(lstCities, cityPopulationLeast),
        max(lstCities, cityNameSortFirst),
        max(lstCities, cityNameSortLast)
    ]

})();
