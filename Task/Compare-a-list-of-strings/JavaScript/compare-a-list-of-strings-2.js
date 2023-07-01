(() => {
    'use strict';

    // allEqual :: [String] -> Bool
    let allEqual = xs => and(zipWith(equal, xs, xs.slice(1))),

        // azSorted :: [String] -> Bool
        azSorted = xs => and(zipWith(azBefore, xs, xs.slice(1))),

        // equal :: a -> a -> Bool
        equal = (a, b) => a === b,

        // azBefore :: String -> String -> Bool
        azBefore = (a, b) => a.toLowerCase() <= b.toLowerCase();


    // GENERIC

    // and :: [Bool] -> Bool
    let and = xs => xs.reduceRight((a, x) => a && x, true),

        // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
        zipWith = (f, xs, ys) => {
            let ny = ys.length;
            return (xs.length <= ny ? xs : xs.slice(0, ny))
                .map((x, i) => f(x, ys[i]));
        };


    // TEST

    let lists = [
        ['isiZulu', 'isiXhosa', 'isiNdebele', 'Xitsonga',
            'Tshivenda', 'Setswana', 'Sesotho sa Leboa', 'Sesotho',
            'English', 'Afrikaans'
        ],
        ['Afrikaans', 'English', 'isiNdebele', 'isiXhosa',
            'isiZulu', 'Sesotho', 'Sesotho sa Leboa', 'Setswana',
            'Tshivenda', 'Xitsonga',
        ],
        ['alpha', 'alpha', 'alpha', 'alpha', 'alpha', 'alpha',
            'alpha', 'alpha', 'alpha', 'alpha', 'alpha', 'alpha'
        ]
    ];

    return {
        allEqual: lists.map(allEqual),
        azSorted: lists.map(azSorted)
    };

})();
