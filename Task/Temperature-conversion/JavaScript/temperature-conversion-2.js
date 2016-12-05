(() => {
    'use strict';

    let kelvinTranslations = k => ['K', 'C', 'F', 'R']
        .map(x => [x, heatBabel(k, 'K', x)]);

    // heatBabel :: Num -> ScaleName -> ScaleName -> Num
    let heatBabel = (n, strFromScale, strToScale) => {
        let ratio = 9 / 5,
            cels = 273.15,
            fahr = 459.67,
            id = x => x,
            readK = {
                k: id,
                c: x => cels + x,
                f: x => (fahr + x) * ratio,
                r: x => x / ratio
            },
            writeK = {
                k: id,
                c: x => x - cels,
                f: x => (x * ratio) - fahr,
                r: x => ratio * x
            };

        return writeK[strToScale.charAt(0).toLowerCase()](
            readK[strFromScale.charAt(0).toLowerCase()](n)
        ).toFixed(2);
    };


    // TEST
    return kelvinTranslations(21)
        .map(([s, n]) => s + ('          ' + n)
            .slice(-10))
        .join('\n');

})();
