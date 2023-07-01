(function () {
    'use strict';

    // find :: (a -> Bool) -> [a] -> Maybe a
    function find(f, xs) {
        for (var i = 0, lng = xs.length; i < lng; i++) {
            if (f(xs[i])) return xs[i];
        }
        return undefined;
    }

    // findIndex :: (a -> Bool) -> [a] -> Maybe Int
    function findIndex(f, xs) {
        for (var i = 0, lng = xs.length; i < lng; i++) {
            if (f(xs[i])) return i;
        }
        return undefined;
    }


    var lst = [
      { "name": "Lagos",                "population": 21.0  },
      { "name": "Cairo",                "population": 15.2  },
      { "name": "Kinshasa-Brazzaville", "population": 11.3  },
      { "name": "Greater Johannesburg", "population":  7.55 },
      { "name": "Mogadishu",            "population":  5.85 },
      { "name": "Khartoum-Omdurman",    "population":  4.98 },
      { "name": "Dar Es Salaam",        "population":  4.7  },
      { "name": "Alexandria",           "population":  4.58 },
      { "name": "Abidjan",              "population":  4.4  },
      { "name": "Casablanca",           "population":  3.98 }
    ];

    return {
        darEsSalaamIndex: findIndex(function (x) {
            return x.name === 'Dar Es Salaam';
        }, lst),

        firstBelow5M: find(function (x) {
                return x.population < 5;
            }, lst)
            .name,

        firstApop: find(function (x) {
                return x.name.charAt(0) === 'A';
            }, lst)
            .population
    };

})();
