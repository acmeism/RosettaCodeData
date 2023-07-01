function isPangram(s) {
    var letters = "zqxjkvbpygfwmucldrhsnioate"
    // sorted by frequency ascending (http://en.wikipedia.org/wiki/Letter_frequency)
    s = s.toLowerCase().replace(/[^a-z]/g,'')
    for (var i = 0; i < 26; i++)
        if (s.indexOf(letters[i]) < 0) return false
    return true
}

console.log(isPangram("is this a pangram"))  // false
console.log(isPangram("The quick brown fox jumps over the lazy dog"))  // true
