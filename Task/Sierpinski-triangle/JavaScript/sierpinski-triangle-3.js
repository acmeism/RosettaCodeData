// A Sierpinski triangle of order N,
// constructed as 2^N lines of Pascal's triangle mod 2
// and mapped to centred {1:asterisk, 0:space} strings

(order => {

    // sierpinski :: Int -> [Bool]
    let sierpinski = intOrder => {

        // asciiPascalMod2 :: Int -> [[Int]]
        let asciiPascalMod2 = nRows =>
            range(1, nRows - 1)
            .reduce(sofar => {
                let lstPrev = sofar.slice(-1)[0];

                // The composition of (asciiBinary . mod 2 . add)
                // is reduced here to a rule from two parent characters
                // to a single child character.

                // Rule 90 also reduces to the same XOR
                // relationship between left and right neighbours.

                return sofar
                    .concat([zipWith(
                        (left, right) => left === right ? ' ' : '*',
                        [' '].concat(lstPrev),
                        lstPrev.concat(' ')
                    )]);
            }, [
                ['*'] // Tip of triangle
            ]);

        // Reduce/folding from the last item (base of list)
        // which has zero left indent.

        // Each preceding row has one more indent space than the row beneath it
        return asciiPascalMod2(Math.pow(2, intOrder))
            .reduceRight((a, x) => {
                return {
                    triangle: a.indent + x.join(' ') + '\n' + a.triangle,
                    indent: a.indent + ' '
                }
            }, {
                triangle: '',
                indent: ''
            }).triangle
    };

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    let zipWith = (f, xs, ys) =>
            xs.length === ys.length ? (
                xs.map((x, i) => f(x, ys[i]))
            ) : undefined,

        // range(intFrom, intTo, optional intStep)
        // Int -> Int -> Maybe Int -> [Int]
        range = (m, n, step) => {
            let d = (step || 1) * (n >= m ? 1 : -1);

            return Array.from({
                length: Math.floor((n - m) / d) + 1
            }, (_, i) => m + (i * d));
        };

    return sierpinski(order);

})(4);
