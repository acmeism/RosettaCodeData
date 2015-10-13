var _ = require("underscore");

// Curried mixin function
// Utility Methods
_.mixin({
  checkAToZ: function(s) {
    return function(letter) {
      if (s.indexOf(letter) != -1) { return true};
    }
  }
});

_.mixin({
  toLower: function(str) {
      return str.toLowerCase();
  }
});

_.mixin({
  isPangram: function(lstr) {
    var letters = "zqxjkvbpygfwmucldrhsnioate".split('');
    return _.every(letters, _.checkAToZ(lstr));
  }
});


var panGramStr = "The quick brown fox jumps over the lazy dog";
var IsPanGram = function(panGramStr) {
    return _.chain(panGramStr).toLower().isPangram().value();
};

console.log("Result IsPanGram - \"", panGramStr,"\" - " , IsPanGram.call(this,panGramStr));
console.log("Result IsPanGram - \"", "the World","\" - ", IsPanGram.call(this, "the World"));

// Result IsPanGram - " The quick brown fox jumps over the lazy dog " -  true
// Result IsPanGram - " the World " -  false
