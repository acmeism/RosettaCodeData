(() => {
    "use strict";

    // ---------- TRADITIONAL CALENDAR STRINGS -----------

    // ats :: Array Int (String, String)
    const ats = () =>
        // 天干 tiangan – 10 heavenly stems
        zip(
            chars("甲乙丙丁戊己庚辛壬癸")
        )(
            words("jiă yĭ bĭng dīng wù jĭ gēng xīn rén gŭi")
        );


    // ads :: Array Int (String, String)
    const ads = () =>
        // 地支 dizhi – 12 terrestrial branches
        zip(
            chars("子丑寅卯辰巳午未申酉戌亥")
        )(
            words(
                "zĭ chŏu yín măo chén sì " + (
                    "wŭ wèi shēn yŏu xū hài"
                )
            )
        );


    // aws :: Array Int (String, String, String)
    const aws = () =>
        // 五行 wuxing – 5 elements
        zip3(
            chars("木火土金水")
        )(
            words("mù huǒ tǔ jīn shuǐ")
        )(
            words("wood fire earth metal water")
        );


    // axs :: Array Int (String, String, String)
    const axs = () =>
        // 十二生肖 shengxiao – 12 symbolic animals
        zip3(
            chars("鼠牛虎兔龍蛇馬羊猴鸡狗豬")
        )(
            words(
                "shǔ niú hǔ tù lóng shé " + (
                    "mǎ yáng hóu jī gǒu zhū"
                )
            )
        )(
            words(
                "rat ox tiger rabbit dragon snake " + (
                    "horse goat monkey rooster dog pig"
                )
            )
        );


    // ays :: Array Int (String, String)
    const ays = () =>
        // 阴阳 yinyang
        zip(
            chars("阳阴")
        )(
            words("yáng yīn")
        );


    // --------------- TRADITIONAL CYCLES ----------------
    const zodiac = y => {
        const
            iYear = y - 4,
            iStem = iYear % 10,
            iBranch = iYear % 12,
            [hStem, pStem] = ats()[iStem],
            [hBranch, pBranch] = ads()[iBranch],
            [hElem, pElem, eElem] = aws()[quot(iStem)(2)],
            [hAnimal, pAnimal, eAnimal] = axs()[iBranch],
            [hYinyang, pYinyang] = ays()[iYear % 2];

        return [
            [
                show(y), hStem + hBranch, hElem,
                hAnimal, hYinyang
            ],
            ["", pStem + pBranch, pElem, pAnimal, pYinyang],
            [
                "", `${show((iYear % 60) + 1)}/60`,
                eElem, eAnimal, ""
            ]
        ];
    };


    // ---------------------- TEST -----------------------
    const main = () => [
            1935, 1938, 1968, 1972, 1976, 1984,
            new Date().getFullYear()
        ]
        .map(showYear)
        .join("\n\n");


    // ------------------- FORMATTING --------------------
    // fieldWidths :: [[Int]]
    const fieldWidths = [
        [6, 10, 7, 8, 3],
        [6, 11, 8, 8, 4],
        [6, 11, 8, 8, 4]
    ];


    // showYear :: Int -> String
    const showYear = y =>
        zipWith(zip)(fieldWidths)(zodiac(y))
        .map(
            row => row.map(
                ([n, s]) => s.padEnd(n, " ")
            )
            .join("")
        )
        .join("\n");


    // ---------------- GENERIC FUNCTIONS ----------------

    // chars :: String -> [Char]
    const chars = s => [...s];


    // quot :: Integral a => a -> a -> a
    const quot = n =>
        m => Math.trunc(n / m);


    // show :: Int -> a -> Indented String
    // show :: a -> String
    const show = (...x) =>
        JSON.stringify.apply(
            null, x.length > 1 ? [
                x[1], null, x[0]
            ] : x
        );


    // words :: String -> [String]
    const words = s =>
        // List of space-delimited sub-strings.
        s.split(/\s+/u);


    // zip :: [a] -> [b] -> [(a, b)]
    const zip = xs =>
        // The paired members of xs and ys, up to
        // the length of the shorter of the two lists.
        ys => Array.from({
            length: Math.min(xs.length, ys.length)
        }, (_, i) => [xs[i], ys[i]]);


    // zip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
    const zip3 = xs =>
        ys => zs => xs.slice(
            0,
            Math.min(...[xs, ys, zs].map(x => x.length))
        )
        .map((x, i) => [x, ys[i], zs[i]]);


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list constructed by zipping with a
        // custom function, rather than with the
        // default tuple constructor.
        xs => ys => xs.map(
            (x, i) => f(x)(ys[i])
        ).slice(
            0, Math.min(xs.length, ys.length)
        );


    // MAIN ---
    return main();
})();
