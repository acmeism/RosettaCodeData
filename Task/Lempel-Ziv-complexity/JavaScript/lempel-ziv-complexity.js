function lempelziv(s) {
  let phrases = [], i = 0;
  const n = s.length;
  if (n === 0) {
    return phrases;
  }
  while (i < n) {
    let k = 1;
    while (i + k <= n && s.substring(0, i + k - 1).includes(s.substring(i, i + k))) {
      k++;
    }
    const phrase = i + k <= n ? s.substring(i, i + k) : s.substring(i, n);
    phrases.push(phrase);
    i += phrase.length;
  }
  return phrases;
}

const tests = ["AZSEDRFTGYGUJIJOKB",
               "ABCABCABCABCABCABC",
               "111011111001111011111001",
               "101001010010111110",
               "1001111011000010",
               "1010101010",
               "1010101010101010",
               "1001111011000010000010",
               "100111101100001000001010",
               "0001101001000101",
               "1111111",
               "0001",
               "010",
               "1",
               "",
               "01011010001101110010",
               "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
               "HELLO WORLD! HELLO WORLD! HELLO WORLD! HELLO WORLD!"];

for (const test of tests) {
  const a = lempelziv(test);
  console.log(`${test} has L-Z complexity: ${a.length}`);
  console.log(`Substrings are: ${a.length === 0 ? "None" : a.join("|")}`);
}
