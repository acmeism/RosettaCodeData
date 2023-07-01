(() => {
    'use strict';

    // stripStart :: Text -> Text
    let stripStart = s => dropWhile(isSpace, s);

    // stripEnd :: Text -> Text
    let stripEnd = s => dropWhileEnd(isSpace, s);

    // strip :: Text -> Text
    let strip = s => dropAround(isSpace, s);
    // OR: let strip = s => s.trim();



    // GENERIC FUNCTIONS

    // dropAround :: (Char -> Bool) -> Text -> Text
    let dropAround = (p, s) => dropWhile(p, dropWhileEnd(p, s));

    // dropWhile :: (a -> Bool) -> [a] -> [a]
    let dropWhile = (p, xs) => {
        for (var i = 0, lng = xs.length;
            (i < lng) && p(xs[i]); i++) {}
        return xs.slice(i);
    }

    // dropWhileEnd :: (Char -> Bool) -> Text -> Text
    let dropWhileEnd = (p, s) => {
        for (var i = s.length; i-- && p(s[i]);) {}
        return s.slice(0, i + 1);
    }

    // isSpace :: Char -> Bool
    let isSpace = c => /\s/.test(c);

    // show :: a -> String
    let show = x => JSON.stringify(x, null, 2);


    // TEST

    let strText = "  \t\t \n \r    Much Ado About Nothing \t \n \r  ";

    return show([stripStart, stripEnd, strip]
        .map(f => '-->' + f(strText) + '<--'));

})();
