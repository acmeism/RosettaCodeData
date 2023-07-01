(() => {

    // .reduceRight() can be useful when reversals
    // are composed with some other process

    let reverse1 = s => Array.from(s)
        .reduceRight((a, x) => a + (x !== ' ' ? x : ' <- '), ''),

        // but ( join . reverse . split ) is faster for
        // simple string reversals in isolation

        reverse2 = s => s.split('').reverse().join('');


    return [reverse1, reverse2]
        .map(f => f("Some string to be reversed"));

})();
