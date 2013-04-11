function range(n) {
  for (let i = 1; i <= n; i++)
    yield i;
}

function factorial(n) {
  return [i for (i in range(n))].reduce(function(a, b) a*b, 1);
}
