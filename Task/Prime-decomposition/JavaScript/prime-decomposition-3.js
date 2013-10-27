function factors(n) {
  if (!n || n < 2)
    return [];

  var f = [];
  for (var i = 2; i <= n; i++){
    while (n % i === 0){
      f.push(i);
      n /= i;
    }
  }

  return f;
};
