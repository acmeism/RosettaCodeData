var encodeMTF = function (word) {
  var init = {wordAsNumbers: [], charList: 'abcdefghijklmnopqrstuvwxyz'.split('')};

  return word.split('').reduce(function (acc, char) {
    var charNum = acc.charList.indexOf(char); //get index of char
    acc.wordAsNumbers.push(charNum); //add original index to acc
    acc.charList.unshift(acc.charList.splice(charNum, 1)[0]); //put at beginning of list
    return acc;
  }, init).wordAsNumbers; //return number list
};

var decodeMTF = function (numList) {
  var init = {word: '', charList: 'abcdefghijklmnopqrstuvwxyz'.split('')};

  return numList.reduce(function (acc, num) {
    acc.word += acc.charList[num];
    acc.charList.unshift(acc.charList.splice(num, 1)[0]); //put at beginning of list
    return acc;
  }, init).word;
};

//test our algorithms
var words = ['broood', 'bananaaa', 'hiphophiphop'];
var encoded = words.map(encodeMTF);
var decoded = encoded.map(decodeMTF);

//print results
console.log("from encoded:");
console.log(encoded);
console.log("from decoded:");
console.log(decoded);
