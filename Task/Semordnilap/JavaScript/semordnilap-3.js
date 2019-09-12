(() => {
    'use strict';

    // semordnilap :: [String] -> String
    const semordnilap = xs => {
        const go = ([s, ws], w) =>
            s.has(w.split('').reverse().join('')) ? (
                [s, [w].concat(ws)]
            ) : [s.add(w), ws];
        return xs.reduce(go, [new Set(), []])[1];
    };

    const main = () => {

        // xs :: [String]
        const xs = semordnilap(
            lines(readFile('unixdict.txt'))
        );

        console.log(xs.length);
        xs.filter(x => 4 < x.length).forEach(
            x => showLog(...[x, x.split('').reverse().join('')])
        )
    };


    // GENERIC FUNCTIONS ----------------------------

    // lines :: String -> [String]
    const lines = s => s.split(/[\r\n]/);

    // readFile :: FilePath -> IO String
    const readFile = fp => {
        const
            e = $(),
            uw = ObjC.unwrap,
            s = uw(
                $.NSString.stringWithContentsOfFileEncodingError(
                    $(fp)
                    .stringByStandardizingPath,
                    $.NSUTF8StringEncoding,
                    e
                )
            );
        return undefined !== s ? (
            s
        ) : uw(e.localizedDescription);
    };

    // showLog :: a -> IO ()
    const showLog = (...args) =>
        console.log(
            args
            .map(JSON.stringify)
            .join(' -> ')
        );

    // MAIN ---
    return main();
})();
