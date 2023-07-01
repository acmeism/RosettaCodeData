function concat() {
  var s = "";
  for (var i = 0; i < arguments.length; i++) {
    s += arguments[i];
  }
  return s;
}
concat("a", "b", "c"); // returns "abc"
