(function (strWords) {

    var strBlocks =
        'BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM',
        blocks = strBlocks.split(' ');

    function abc(lstBlocks, strWord) {
        var lngChars = strWord.length;

        if (!lngChars) return [];

        var b = lstBlocks[0],
            c = strWord[0];

        return chain(lstBlocks, function (b) {
            return (b.indexOf(c.toUpperCase()) !== -1) ? [
                (b + ' ').concat(
                    abc(removed(b, lstBlocks), strWord.slice(1)))
            ] : [];
        })
    }

    // Monadic bind (chain) for lists
    function chain(xs, f) {
        return [].concat.apply([], xs.map(f));
    }

    // a -> [a] -> [a]
    function removed(x, xs) {
        var h = xs.length ? xs[0] : null,
            t = h ? xs.slice(1) : [];

        return h ? (
            h === x ? t : [h].concat(removed(x, t))
        ) : [];
    }

    function solution(strWord) {
        var strAttempt = abc(blocks, strWord)[0].split(',')[0];

        // two chars per block plus one space -> 3
        return strWord + ((strAttempt.length === strWord.length * 3) ?
            ' -> ' + strAttempt : ': [no solution]');
    }

    return strWords.split(' ').map(solution).join('\n');

})('A bark BooK TReAT COMMON squAD conFUSE');
