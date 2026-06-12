(() => {
    "use strict";

    // ----- MORE THAN THREE VOWELS, AND NONE BUT E ------

    // p :: String -> Bool
    const p = w => {
        // True if the word contains more than three vowels,
        // and none of its vowels are other than "e".
        const
            [noOtherVowels, eCount] = [...w].reduce(
                ([bool, n], c) => bool
                    ? "e" === c
                        ? [bool, 1 + n]
                        : "aiou".includes(c)
                            ? [false, n]
                            : [bool, n]
                    : [false, n],

                // Initial accumulator.
                [true, 0]
            );

        return noOtherVowels && (3 < eCount);
    };

    // ---------------------- TEST -----------------------
    const main = () =>
        lines(
            readFile(
                "~/Desktop/unixdict.txt"
            )
        )
        .filter(p)
        .join("\n");

    // --------------------- GENERIC ---------------------

    // lines :: String -> [String]
    const lines = s =>
        // A list of strings derived from a single string
        // which is delimited by \n or by \r\n or \r.
        0 < s.length
            ? s.split(/\r\n|\n|\r/u)
            : [];

    // ----------------------- jxa -----------------------

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
