function shuffle(str) {
  var a = str.split(''), b, c = a.length, d
  while (c) b = Math.random() * c-- | 0, d = a[c], a[c] = a[b], a[b] = d
  return a.join('')
}

function isBalanced(str) {
  var a = str, b
  do { b = a, a = a.replace(/\[\]/g, '') } while (a != b)
  return !a
}

var M = 20
while (M-- > 0) {
  var N = Math.random() * 10 | 0, bs = shuffle('['.repeat(N) + ']'.repeat(N))
  console.log('"' + bs + '" is ' + (isBalanced(bs) ? '' : 'un') + 'balanced')
}
