(() => {

    // jewelCount :: String -> String -> Int
    const jewelCount = (j, s) => {
        const js = j.split('');
        return s.split('')
            .reduce((a, c) => js.includes(c) ? a + 1 : a, 0)
    };

    // TEST -----------------------------------------------
    return [
            ['aA', 'aAAbbbb'],
            ['z', 'ZZ']
        ]
        .map(x => jewelCount(...x))
})();
