function countSubstring(str, subStr) {
    var matches = str.match(new RegExp(subStr, "g"));
    return matches ? matches.length : 0;
}
