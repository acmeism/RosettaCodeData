function makeList(separator) {
  var counter = 1;

  function makeItem(item) {
    return counter++ + separator + item + "\n";
  }

  return makeItem("first") + makeItem("second") + makeItem("third");
}

console.log(makeList(". "));
