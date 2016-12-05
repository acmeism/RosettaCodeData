(function (strSample) {

    // isPalindrome :: String -> Bool
    let isPalindrome = s =>
        s.split('')
        .reverse()
        .join('') === s;



    // TESTING

    // lowerCaseNoSpace :: String -> String
    let lowerCaseNoSpace = s =>
        concatMap(c => c !== ' ' ? [c.toLowerCase()] : [],
            s.split(''))
        .join(''),

        // concatMap :: (a -> [b]) -> [a] -> [b]
        concatMap = (f, xs) => [].concat.apply([], xs.map(f));


    return isPalindrome(
        lowerCaseNoSpace(strSample)
    );


})("In girum imus nocte et consumimur igni");
