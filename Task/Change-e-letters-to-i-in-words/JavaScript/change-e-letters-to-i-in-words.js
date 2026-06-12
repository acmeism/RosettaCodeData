(() => {
    "use strict";

    // ieTwins :: String -> [(String, String)]
    const ieTwins = s => {
        const
            longWords = s.split("\n")
            .filter(x => 5 < x.length),
            lexicon = new Set(
                longWords.filter(w => w.includes("i"))
            ),
            rgx = /e/gu;

        return longWords.flatMap(
            w => w.includes("e") ? (() => {
                const x = w.replace(rgx, "i");

                return lexicon.has(x) ? [
                    [w, x]
                ] : [];
            })() : []
        );
    };

    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => {
        const s = readFile("unixdict.txt");

        return ieTwins(s)
            .map(JSON.stringify)
            .join("\n");
    };

    // --------------------- GENERIC ---------------------

    // readFile :: FilePath -> IO String
    const readFile = fp => {
        // The contents of a text file at the
        // filepath fp.
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
