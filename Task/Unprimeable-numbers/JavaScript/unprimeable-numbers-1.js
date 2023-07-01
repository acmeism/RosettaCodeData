Number.prototype.isPrime = function() {
  let i = 2, num = this;
  if (num == 0 || num == 1) return false;
  if (num == 2) return true;
  while (i <= Math.ceil(Math.sqrt(num))) {
    if (num % i == 0) return false;
    i++;
  }
  return true;
}
