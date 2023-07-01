function getLis(input) {
  if (input.length === 0) {
    return [];
  }

  var lisLenPerIndex = [];
  let max = { index: 0, length: 1 };

  for (var i = 0; i < input.length; i++) {
    lisLenPerIndex[i] = 1;
    for (var j = i - 1; j >= 0; j--) {
      if (input[i] > input[j] && lisLenPerIndex[j] >= lisLenPerIndex[i]) {
        var length = lisLenPerIndex[i] = lisLenPerIndex[j] + 1;
        if (length > max.length) {
          max = { index: i, length };
        }
      }
    }
  }

  var lis = [input[max.index]];
  for (var i = max.index; i >= 0 && max.length !== 0; i--) {
    if (input[max.index] > input[i] && lisLenPerIndex[i] === max.length - 1) {
      lis.unshift(input[i]);
      max.length--;
    }
  }

  return lis;
}

console.log(getLongestIncreasingSubsequence([0, 7, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]));
console.log(getLongestIncreasingSubsequence([3, 2, 6, 4, 5, 1]));
