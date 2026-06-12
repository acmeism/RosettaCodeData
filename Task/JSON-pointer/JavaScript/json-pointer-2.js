(() => {
    "use strict";

    // ------------------ JSON POINTER -------------------

    // jsonPointLR :: JSON -> String -> Either String a
    const jsonPointLR = json =>
        // Either a message reporting an ill-formed input,
        // (bad JSON string or bad JSON pointer string),
        // or a pointer-referenced value within a JS Object.
        compose(
            bindLR(
                jsonParseLR(json)
            ),
            jsoPointLR
        );


    // jsoPointLR :: String -> a -> Either String a
    const jsoPointLR = pointer =>
        // Either a message reporting an ill-formed pointer,
        // or a pointer-referenced value within a JS Object.
        jsObject => {
            const parts = pointer.split("/");

            // subValueLR :: (Either String a, String, Int)
            // -> Either String a
            const subValueLR = (lr, k, i) =>
                // Either an explanatory message, or the subvalue
                // referenced by the next segment of a JSON pointer.
                bindLR(lr)(v => {
                    const
                        x = v[
                            k
                                .replaceAll("~0", "~")
                                .replaceAll("~1", "/")
                        ];

                    return undefined !== x
                        ? Right(x)
                        : Left(unwords([
                            "No value found at:",
                            `'${parts.slice(0, 2 + i).join("/")}'`
                        ]))
                });

            return 0 < parts[0].length
                ? Left(`Bad pointer: '${pointer}'`)
                : parts.slice(1).reduce(
                    subValueLR,
                    Right(jsObject)
                );
        };





    // ---------------------- TEST -----------------------
    const main = () => {

        const
            pointTest = jsonPointLR(`{
                "wiki": {
                    "links": [
                    "https://rosettacode.org/wiki/Rosetta_Code",
                    "https://discord.com/channels/1011262808001880065"
                    ]
                },
                "": "Rosetta",
                " ": "Code",
                "g/h": "chrestomathy",
                "i~j": "site",
                "abc": ["is", "a"],
                "def": { "": "programming" }
            }`);

        return unlines([
            "",
            "/",
            "/ ",
            "/abc",
            "/def/",
            "/g~1h",
            "/i~0j",
            "/wiki/links/0",
            "/wiki/links/1",
            "/wiki/links/2",
            "/wiki/name",
            "/no/such/thing",
            "bad/pointer",
        ]
            .map(
                k => either(
                    msg => msg
                )(
                    x => `'${k}' -> ${JSON.stringify(x)}`
                )(
                    pointTest(k)
                )
            )
        );
    }

    // --------------------- GENERIC ---------------------

    // Left :: a -> Either a b
    const Left = x => ({
        type: "Either",
        Left: x
    });


    // Right :: b -> Either a b
    const Right = x => ({
        type: "Either",
        Right: x
    });


    // bindLR (>>=) :: Either a ->
    // (a -> Either b) -> Either b
    const bindLR = lr =>
        // Bind operator for the Either option type.
        // If lr has a Left value then lr unchanged,
        // otherwise the function mf applied to the
        // Right value in lr.
        mf => "Left" in lr
            ? lr
            : mf(lr.Right);


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // either :: (a -> c) -> (b -> c) -> Either a b -> c
    const either = fl =>
        // Application of the function fl to the
        // contents of any Left value in e, or
        // the application of fr to its Right value.
        fr => e => "Left" in e
            ? fl(e.Left)
            : fr(e.Right);


    // jsonParseLR :: String -> Either String a
    const jsonParseLR = s => {
        try {
            return Right(JSON.parse(s));
        } catch (e) {
            return Left(
                unlines([
                    e.message,
                    `(line:${e.line} col:${e.column})`
                ])
            );
        }
    };


    // unlines :: [String] -> String
    const unlines = xs =>
        // A single string formed by the intercalation
        // of a list of strings with the newline character.
        xs.join("\n");


    // unwords :: [String] -> String
    const unwords = xs =>
        // A space-separated string derived
        // from a list of words.
        xs.join(" ");

    // MAIN ---
    return main();
})();
