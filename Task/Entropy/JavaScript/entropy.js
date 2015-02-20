(function(shannon) {
  // Create a dictionary of character frequencies and iterate over it.
  function process(s, evaluator) {
    var h = Object.create(null), k;
    s.split('').forEach(function(c) {
      h[c] && h[c]++ || (h[c] = 1); });
    if (evaluator) for (k in h) evaluator(k, h[k]);
    return h;
  };
  // Measure the entropy of a string in bits per symbol.
  shannon.entropy = function(s) {
    var sum = 0,len = s.length;
    process(s, function(k, f) {
      var p = f/len;
      sum -= p * Math.log(p) / Math.log(2);
    });
    return sum;
  };
})(window.shannon = window.shannon || {});

// Log the Shannon entropy of a string.
function logEntropy(s) {
  console.log('Entropy of "' + s + '" in bits per symbol:', shannon.entropy(s));
}

logEntropy('1223334444');
logEntropy('0');
logEntropy('01');
logEntropy('0123');
logEntropy('01234567');
logEntropy('0123456789abcdef');
