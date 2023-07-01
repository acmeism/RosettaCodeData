function quibble(words) {
  var words2 = words.join()

  var words3 = [...words2].reverse().join('');
  var res = words3.replace(",", " dna ");
  var words4 = [...res].reverse().join('');

  return '{'+words4+'}';
}
