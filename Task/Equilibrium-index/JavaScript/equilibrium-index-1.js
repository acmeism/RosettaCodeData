function equilibrium(a) {
  var N = a.length, i, l = [], r = [], e = []
  for (l[0] = a[0], r[N - 1] = a[N - 1], i = 1; i<N; i++)
    l[i] = l[i - 1] + a[i], r[N - i - 1] = r[N - i] + a[N - i - 1]
  for (i = 0; i < N; i++)
    if (l[i] === r[i]) e.push(i)
  return e
}

// test & output
[ [-7, 1, 5, 2, -4, 3, 0], // 3, 6
  [2, 4, 6], // empty
  [2, 9, 2], // 1
  [1, -1, 1, -1, 1, -1, 1], // 0,1,2,3,4,5,6
  [1], // 0
  [] // empty
].forEach(function(x) {
  console.log(equilibrium(x))
});
