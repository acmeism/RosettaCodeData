function reverseString(str){
  return str.split("").reverse().join("");
}

function isPalindrome(str) {
  return str == reverseString(str);
}

alert(isPalindrome("ingirumimusnocteetconsumimurigni"));
