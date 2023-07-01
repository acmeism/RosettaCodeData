var fs = require('fs');
var words = fs.readFileSync('unixdict.txt', 'UTF-8').split('\n');

var i, item, max = 0,
    anagrams = {};

for (i = 0; i < words.length; i += 1) {
  var key = words[i].split('').sort().join('');
  if (!anagrams.hasOwnProperty(key)) {//check if property exists on current obj only
      anagrams[key] = [];
  }
  var count = anagrams[key].push(words[i]); //push returns new array length
  max = Math.max(count, max);
}

//note, this returns all arrays that match the maximum length
for (item in anagrams) {
  if (anagrams.hasOwnProperty(item)) {//check if property exists on current obj only
    if (anagrams[item].length === max) {
        console.log(anagrams[item].join(' '));
    }
  }
}
