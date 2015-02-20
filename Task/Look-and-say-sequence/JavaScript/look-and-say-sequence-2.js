function lookSay(digits) {
    var result = '',
        chars = (digits + ' ').split(''),
        lastChar = chars[0],
        times = 0;

    chars.forEach(function(nextChar) {
        if (nextChar === lastChar) {
            times++;
        }
        else {
            result += (times + '') + lastChar;
            lastChar = nextChar;
            times = 1;
        }
    });

    return result;
}

(function output(seed, iterations) {
    for (var i = 0; i < iterations; i++) {
        console.log(seed);
        seed = lookSay(seed);
    }
})("1", 10);
