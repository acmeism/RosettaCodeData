function takeWhile(lst, fnTest) {
    'use strict';
    var varHead = lst.length ? lst[0] : null;

    return varHead ? (
        fnTest(varHead) ? [varHead].concat(
            takeWhile(lst.slice(1), fnTest)
        ) : []
    ) : [];
}
