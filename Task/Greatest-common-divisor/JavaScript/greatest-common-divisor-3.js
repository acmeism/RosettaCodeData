function GCD(arr) {
  var i, y,
      n = arr.length,
      x = Math.abs(arr[0]);

  for (i = 1; i < n; i++) {
    y = Math.abs(arr[i]);

    while (x && y) {
      (x > y) ? x %= y : y %= x;
    }
    x += y;
  }
  return x;
}

//For example:
GCD([57,0,-45,-18,90,447]); //=> 3
