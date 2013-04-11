mod10check = function(cc) {
  return $A(cc).reverse().map(Number).inject(0, function(s, d, i) {
    return s + (i % 2 == 1 ? (d == 9 ? 9 : (d * 2) % 9) : d);
  }) % 10 == 0;
};
['49927398716','49927398717','1234567812345678','1234567812345670'].each(function(i){alert(mod10check(i))});
