function sumsq(array) {
  var sum = 0,
      i = array.length;

  while (i--) sum += Math.pow(array[i], 2);

  return sum;
}

alert(sumsq([1,2,3,4,5])); // 55
