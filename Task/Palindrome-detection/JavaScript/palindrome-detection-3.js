(() => {

    // isPalindrome :: String -> Bool
    const isPalindrome = s => {
        const cs = filter(c => ' ' !== c, s.toLocaleLowerCase());
        return cs.join('') === reverse(cs).join('');
    };


    // TEST -----------------------------------------------
    const main = () =>
        isPalindrome(
            'In girum imus nocte et consumimur igni'
        )

    // GENERIC FUNCTIONS ----------------------------------

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => (
        'string' !== typeof xs ? (
            xs
        ) : xs.split('')
    ).filter(f);

    // reverse :: [a] -> [a]
    const reverse = xs =>
        'string' !== typeof xs ? (
            xs.slice(0).reverse()
        ) : xs.split('').reverse().join('');

    // MAIN ---
    return main();
})();
