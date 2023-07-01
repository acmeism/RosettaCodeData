function getLIS(input) {
  if (input.length === 0) {
    return 0;
  }

  const piles = [input[0]];

  for (let i = 1; i < input.length; i++) {
    const leftPileIdx = binarySearch(piles, input[i]);

    if (leftPileIdx !== -1) {
      piles[leftPileIdx] = input[i];
    } else {
      piles.push(input[i]);
    }
  }

  return piles.length;
}

function binarySearch(arr, target) {
  let lo = 0;
  let hi = arr.length - 1;

  while (lo <= hi) {
    const mid = lo + Math.floor((hi - lo) / 2);

    if (arr[mid] >= target) {
      hi = mid - 1;
    } else {
      lo = mid + 1;
    }
  }

  return lo < arr.length ? lo : -1;
}

console.log(getLongestIncreasingSubsequence([0, 7, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]));
console.log(getLongestIncreasingSubsequence([3, 2, 6, 4, 5, 1]));
