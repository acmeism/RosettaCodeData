function factorial(n) {
  //check our edge case
  if (n < 0) { throw "Number must be non-negative"; }

  var sum = 1;
  //we skip zero and one since both are 1 and are identity
  while (n > 1) {
    sum *= n;
    n--;
  }
  return sum;
}
