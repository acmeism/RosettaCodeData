function quibble(words) {
  return "{" +
    words.slice(0, words.length-1).join(",") +
   (words.length > 1 ? " and " : "") +
   (words[words.length-1] || '') +
  "}";
}

[[], ["ABC"], ["ABC", "DEF"], ["ABC", "DEF", "G", "H"]].forEach(
  function(s) {
    console.log(quibble(s));
  }
);
