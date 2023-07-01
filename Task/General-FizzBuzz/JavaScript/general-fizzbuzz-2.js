function fizz(lstRules, lngMax) {

    return (
        function rng(i) {
            return i ? rng(i - 1).concat(i) : []
        }
    )(lngMax).reduce(
        function (strSeries, n) {

            // The next member of the series of lines:
            // a word string or a number string
            return strSeries + (
                lstRules.reduce(
                    function (str, tplNumWord) {
                        return str + (
                            n % tplNumWord[0] ? '' : tplNumWord[1]
                        )
                    }, ''
                ) || n.toString()
            ) + '\n';

        }, ''
    );
}

fizz([[3, 'Fizz'], [5, 'Buzz'], [7, 'Baxx']], 20);
