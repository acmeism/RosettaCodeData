var fs = require('fs');
var dictionary = fs.readFileSync('unixdict.txt', 'UTF-8').split('\n');

//group anagrams
var sortedDict = dictionary.reduce(function (acc, word) {
  var sortedLetters = word.split('').sort().join('');
  if (acc[sortedLetters] === undefined) { acc[sortedLetters] = []; }
  acc[sortedLetters].push(word);
  return acc;
}, {});

//sort list by frequency
var keysSortedByFrequency = Object.keys(sortedDict).sort(function (keyA, keyB) {
  if (sortedDict[keyA].length < sortedDict[keyB].length) { return 1; }
  if (sortedDict[keyA].length > sortedDict[keyB].length) { return -1; }
  return 0;
});

//print first 10 anagrams by frequency
keysSortedByFrequency.slice(0, 10).forEach(function (key) {
  console.log(sortedDict[key].join(' '));
});
