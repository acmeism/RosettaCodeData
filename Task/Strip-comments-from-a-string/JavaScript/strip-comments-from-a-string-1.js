function stripComments(s) {
  var re1 = /^\s+|\s+$/g;  // Strip leading and trailing spaces
  var re2 = /\s*[#;].+$/g; // Strip everything after # or ; to the end of the line, including preceding spaces
  return s.replace(re1,'').replace(re2,'');
}


var s1 = 'apples, pears # and bananas';
var s2 = 'apples, pears ; and bananas';

alert(stripComments(s1) + '\n' + stripComments(s2));
