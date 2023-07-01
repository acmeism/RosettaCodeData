(() => {
    "use strict";

    // ------------------- WORD WHEEL --------------------

    // gridWords :: [String] -> [String] -> [String]
    const gridWords = grid =>
        lexemes => {
            const
                wheel = sort(toLower(grid.join(""))),
                wSet = new Set(wheel),
                mid = wheel[4];

            return lexemes.filter(w => {
                const cs = [...w];

                return 2 < cs.length && cs.every(
                    c => wSet.has(c)
                ) && cs.some(x => mid === x) && (
                    wheelFit(wheel, cs)
                );
            });
        };


    // wheelFit :: [Char] -> [Char] -> Bool
    const wheelFit = (wheel, word) => {
        const go = (ws, cs) =>
            0 === cs.length ? (
                true
            ) : 0 === ws.length ? (
                false
            ) : ws[0] === cs[0] ? (
                go(ws.slice(1), cs.slice(1))
            ) : go(ws.slice(1), cs);

        return go(wheel, sort(word));
    };


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        gridWords(["NDE", "OKG", "ELW"])(
            lines(readFile("unixdict.txt"))
        )
        .join("\n");


    // ---------------- GENERIC FUNCTIONS ----------------

    // lines :: String -> [String]
    const lines = s =>
        // A list of strings derived from a single string
        // which is delimited by \n or by \r\n or \r.
        Boolean(s.length) ? (
            s.split(/\r\n|\n|\r/u)
        ) : [];


    // readFile :: FilePath -> IO String
    const readFile = fp => {
        // The contents of a text file at the
        // given file path.
        const
            e = $(),
            ns = $.NSString
            .stringWithContentsOfFileEncodingError(
                $(fp).stringByStandardizingPath,
                $.NSUTF8StringEncoding,
                e
            );

        return ObjC.unwrap(
            ns.isNil() ? (
                e.localizedDescription
            ) : ns
        );
    };


    // sort :: Ord a => [a] -> [a]
    const sort = xs =>
        Array.from(xs).sort();


    // toLower :: String -> String
    const toLower = s =>
        // Lower-case version of string.
        s.toLocaleLowerCase();


    // MAIN ---
    return main();
})();
