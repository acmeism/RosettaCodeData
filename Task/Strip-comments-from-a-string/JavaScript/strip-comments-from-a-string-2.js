var stripComments = (function () {
  var re1 = /^\s+|\s+$/g;
  var re2 = /\s*[#;].+$/g;
  return function (s) {
    return s.replace(re1,'').replace(re2,'');
  };
}());
