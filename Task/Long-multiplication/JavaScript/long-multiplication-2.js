(function () {
    'use strict';

    // Javascript lacks an unbounded integer type
    // so this multiplication function takes and returns
    // long integer strings rather than any kind of native integer


    // longMult :: (String | Integer) -> (String | Integer) -> String
    function longMult(num1, num2) {
        return largeIntegerString(
            digitProducts(digits(num1), digits(num2))
        );
    }



    // digitProducts :: [Int] -> [Int] -> [Int]
    function digitProducts(xs, ys) {
        return multTable(xs, ys)
            .map(function (zs, i) {
                return Array.apply(null, Array(i))
                    .map(function () {
                        return 0;
                    })
                    .concat(zs);
            })
            .reduce(function (a, x) {
                if (a) {
                    var lng = a.length;

                    return x.map(function (y, i) {
                        return y + (i < lng ? a[i] : 0);
                    })

                } else return x;
            })
    }


    // largeIntegerString :: [Int] -> String
    function largeIntegerString(lstColumnValues) {
        var dctProduct = lstColumnValues
            .reduceRight(function (a, x) {
                var intSum = x + a.carried,
                    intDigit = intSum % 10;

                return {
                    digits: intDigit
                        .toString() + a.digits,
                    carried: (intSum - intDigit) / 10
                };
            }, {
                digits: '',
                carried: 0
            });

        return (dctProduct.carried > 0 ? (
            dctProduct.carried.toString()
        ) : '') + dctProduct.digits;
    }


    // multTables :: [Int] -> [Int] -> [[Int]]
    function multTable(xs, ys) {
        return ys.map(function (y) {
            return xs.map(function (x) {
                return x * y;
            })
        });
    }

    // digits :: (Integer | String) -> [Integer]
    function digits(n) {
        return (typeof n === 'string' ? n : n.toString())
            .split('')
            .map(function (x) {
                return parseInt(x, 10);
            });
    }


    // TEST showing that larged bounded integer inputs give only rounded results
    // whereas integer string inputs allow for full precision on this scale (2^128)


    return {
        fromIntegerStrings: longMult(
            '18446744073709551616',
            '18446744073709551616'
        ),
        fromBoundedIntegers: longMult(
            18446744073709551616,
            18446744073709551616
        )
    };

})();
