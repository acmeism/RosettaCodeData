#!/usr/bin/env js

function main() {
    var wordList = read('unixdict.txt').split(/\s+/);
    var anagrams = findAnagrams(wordList);
    var derangedAnagrams = findDerangedAnagrams(anagrams);
    var longestPair = findLongestDerangedPair(derangedAnagrams);
    print(longestPair.join(' '));

}

function findLongestDerangedPair(danas) {
    var longestLen = danas[0][0].length;
    var longestPair = danas[0];
    for (var i in danas) {
        if (danas[i][0].length > longestLen) {
            longestLen = danas[i][0].length;
            longestPair = danas[i];
        }
    }
    return longestPair;
}

function findDerangedAnagrams(anagrams) {
    var deranged = [];

    function isDeranged(w1, w2) {
        for (var c = 0; c < w1.length; c++) {
            if (w1[c] == w2[c]) {
                return false;
            }
        }
        return true;
    }

    function findDeranged(anas) {
        for (var a = 0; a < anas.length; a++) {
            for (var b = a + 1; b < anas.length; b++) {
                if (isDeranged(anas[a], anas[b])) {
                    deranged.push([anas[a], anas[b]]);
                }
            }
        }
    }

    for (var a in anagrams) {
        var anas = anagrams[a];
        findDeranged(anas);
    }

    return deranged;
}

function findAnagrams(wordList) {
    var anagrams = {};

    for (var wordNum in wordList) {
        var word = wordList[wordNum];
        var key = word.split('').sort().join('');
        if (!(key in anagrams)) {
            anagrams[key] = [];
        }
        anagrams[key].push(word);
    }

    for (var a in anagrams) {
        if (anagrams[a].length < 2) {
            delete(anagrams[a]);
        }
    }

    return anagrams;
}

main();
