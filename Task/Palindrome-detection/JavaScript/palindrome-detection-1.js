String.prototype.reverse = function(){ return this.split("").reverse().join(""); }

function palindrome(str) { return str == str.reverse(); }

alert(palindrome("ingirumimusnocteetconsumimurigni"));
