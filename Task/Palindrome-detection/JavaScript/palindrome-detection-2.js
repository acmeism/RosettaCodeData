function reverseStr(s) {
  var i, o = '';
  for (i = s.length - 1; i >= 0; o += s[i--]);
  return o;
};

function isPalindrome(str) {
    var s = str.toLowerCase().replace(/[^a-z]/g, '');
    return (reverseStr(s) === s);
};

isPalindrome('A man, a plan, a canoe, pasta, heros, rajahs, ' +
             'a coloratura, maps, snipe, percale, macaroni, ' +
             'a gag, a banana bag, a tan, a tag, ' +
             'a banana bag again (or a camel), a crepe, pins, ' +
             'Spam, a rut, a Rolo, cash, a jar, sore hats, ' +
             'a peon, a canal – Panama!');
