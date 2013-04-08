#!/usr/bin/env js

var anas = {};
var words = read('unixdict.txt').split(/\n/g);

for (var w in words) {
    var key = words[w].split("").sort().join('');
    if (!(key in anas)) {
        anas[key] = [];
    }
    anas[key].push(words[w]);
}

for (var a in anas) {
    if (anas[a].length >= 2) {
        print(anas[a]);
    }
}

quit();
