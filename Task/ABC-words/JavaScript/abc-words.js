(() => {
    "use strict";

    // -------------------- ABC WORDS --------------------

    // isABC :: String -> Bool
    const isABC = s =>
        // True if the string contains each of 'a' 'b' 'c',
        // and their first occurrences in the string are
        // in that alphabetical order.
        bind(
            bind(
                residue("a")("bc")(s)
            )(
                residue("b")("c")
            )
        )(
            r => r.includes("c") || null
        ) !== null;


    // residue :: Char -> String -> String -> Maybe String
    const residue = c =>
        // Any characters remaining in a given string
        // after the first occurrence of c, or null
        // if c is not found, or is preceded by any
        // excluded characters.
        excluded => {
            const go = t =>
                (0 < t.length) ? (() => {
                    const x = t[0];

                    return excluded.includes(x) ? (
                        null
                    ) : c === x ? (
                        t.slice(1)
                    ) : go(t.slice(1));
                })() : null;

            return go;
        };


    // ---------------------- TEST -----------------------
    const main = () =>
        lines(readFile("~/unixdict.txt"))
        .filter(isABC)
        .map((x, i) => `(${1 + i}, ${x})`)
        .join("\n");


    // --------------------- GENERIC ---------------------

    // bind (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
    const bind = mb =>
    // Null if mb is null, or the application of the
    // (a -> Maybe b) function mf to the contents of mb.
        mf => null === mb ? (
            mb
        ) : mf(mb);


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


    // MAIN ---
    return main();
})();
