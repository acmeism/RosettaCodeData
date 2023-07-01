#!/usr/bin/env rhino

importPackage (java.io)

var dictFile = arguments[0] || "unixdict.txt";

var reader = new BufferedReader(new FileReader(dictFile));
var dict = {};
var word;
while (word = reader.readLine()) {
  dict[word] = word.split("").reverse().join("");
}

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
print("There are " + count + " semordnilaps in " +
      dictFile + ".  Here are 5:" );
var indices=[]
for (var i=0; i<count; ++i) {
  if (Math.random() < 1/Math.ceil(i/5.0)) {
     indices[i%5] = i
  }
}
indices.sort()
for (var i=0; i<5; ++i) {
  print(semordnilaps[indices[i]]);
}
