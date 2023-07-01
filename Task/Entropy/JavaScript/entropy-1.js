// Shannon entropy in bits per symbol.
function entropy(str) {
  const len = str.length

  // Build a frequency map from the string.
  const frequencies = Array.from(str)
    .reduce((freq, c) => (freq[c] = (freq[c] || 0) + 1) && freq, {})

  // Sum the frequency of each character.
  return Object.values(frequencies)
    .reduce((sum, f) => sum - f/len * Math.log2(f/len), 0)
}

console.log(entropy('1223334444'))        // 1.8464393446710154
console.log(entropy('0'))                 // 0
console.log(entropy('01'))                // 1
console.log(entropy('0123'))              // 2
console.log(entropy('01234567'))          // 3
console.log(entropy('0123456789abcdef'))  // 4
