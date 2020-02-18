function stackermann(M, N) {
  const stack = [];
  for (;;) {
    if (M === 0) {
      N++;
      if (stack.length === 0) return N;
      const r = stack[stack.length-1];
      if (r[1] === 1) stack.length--;
      else r[1]--;
      M = r[0];
    } else if (N === 0) {
      M--;
      N = 1;
    } else {
      M--
      stack.push([M, N]);
      N = 1;
    }
  }
}
