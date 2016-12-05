//using chained methods
function reverseStr(s) {
  return s.split('').reverse().join('');
}

//fast method using for loop
function reverseStr(s) {
  for (var i = s.length - 1, o = ''; i >= 0; o += s[i--]) { }
  return o;
}

//fast method using while loop (faster with long strings in some browsers when compared with for loop)
function reverseStr(s) {
  var i = s.length, o = '';
  while (i--) o += s[i];
  return o;
}
