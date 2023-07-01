const entropy = (s) => {
  const split = s.split('');
  const counter = {};
  split.forEach(ch => {
    if (!counter[ch]) counter[ch] = 1;
    else counter[ch]++;
  });


  const lengthf = s.length * 1.0;
  const counts = Object.values(counter);
  return -1 * counts
    .map(count => count / lengthf * Math.log2(count / lengthf))
    .reduce((a, b) => a + b);
};
