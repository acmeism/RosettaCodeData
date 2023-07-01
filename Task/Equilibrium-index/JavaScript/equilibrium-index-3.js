function equilibrium(arr) {
  let sum = arr.reduce((a, b) => a + b);
  let leftSum = 0;

  for (let i = 0; i < arr.length; ++i) {
    sum -= arr[i];

    if (leftSum === sum) {
      return i;
    }

    leftSum += arr[i];
  }

  return -1;
}
