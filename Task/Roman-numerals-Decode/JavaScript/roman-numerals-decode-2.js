(function (lstTest) {

    var mapping = [["M", 1000], ["CM", 900], ["D", 500], ["CD", 400], ["C", 100], [
        "XC", 90], ["L", 50], ["XL", 40], ["X", 10], ["IX", 9], ["V", 5], ["IV",
        4], ["I", 1]];

    // s -> n
    function romanValue(s) {
        // recursion over list of characters
        // [c] -> n
        function toArabic(lst) {
            return lst.length ? function (xs) {
                var lstParse = chain(mapping, function (lstPair) {
                    return isPrefixOf(
                        lstPair[0], xs
                    ) ? [lstPair[1], drop(lstPair[0].length, xs)] : []
                });
                return lstParse[0] + toArabic(lstParse[1]);
            }(lst) : 0
        }
        return toArabic(s.split(''));
    }

    // Monadic bind (chain) for lists
    function chain(xs, f) {
        return [].concat.apply([], xs.map(f));
    }

    // [a] -> [a] -> Bool
    function isPrefixOf(lstFirst, lstSecond) {
        return lstFirst.length ? (
            lstSecond.length ?
            lstFirst[0] === lstSecond[0] && isPrefixOf(
                lstFirst.slice(1), lstSecond.slice(1)
            ) : false
        ) : true;
    }

    // Int -> [a] -> [a]
    function drop(n, lst) {
        return n <= 0 ? lst : (
            lst.length ? drop(n - 1, lst.slice(1)) : []
        );
    }

    return lstTest.map(romanValue);

})(['MCMXC', 'MDCLXVI', 'MMVIII']);
