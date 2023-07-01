#!/usr/bin/env node
var  fs = require('fs');
var sys = require('sys');

var dictFile = process.argv[2] || "unixdict.txt";

var dict = {};
fs.readFileSync(dictFile)
  .toString()
  .split('\n')
  .forEach(function(word) {
    dict[word] = word.split("").reverse().join("");
  });

function isSemordnilap(word) { return dict[dict[word]]; };

var semordnilaps = []
for (var key in dict) {
  if (isSemordnilap(key)) {
    var rev = dict[key];
    if (key < rev) {
      semordnilaps.push([key,rev]) ;
    }
  }
}

var count = semordnilaps.length;
sys.puts("There are " + count + " semordnilaps in " +
         dictFile + ".  Here are 5:" );

var indices=[]
for (var i=0; i<count; ++i) {
  if (Math.random() < 1/Math.ceil(i/5.0)) {
    indices[i%5] = i
  }
}
indices.sort()
for (var i=0; i<5; ++i) {
  sys.puts(semordnilaps[indices[i]]);
}
