const dutchNationalFlag = () => {

  /**
   * Return the name of the given number in this way:
   * 0 = Red
   * 1 = White
   * 2 = Blue
   * @param {!number} e
   */
  const name = e => e > 1 ? 'Blue' : e > 0 ? 'White' : 'Red';

  /**
   * Given an array of numbers return true if each number is bigger than
   * or the same as the previous
   * @param {!Array<!number>} arr
   */
  const isSorted = arr => arr.every((e,i) => e >= arr[Math.max(i-1, 0)]);

  /**
   * Generator that keeps yielding a random int between 0(inclusive) and
   * max(exclusive), up till n times, and then is done.
   * @param max
   * @param n
   */
  function* randomGen (max, n) {
    let i = 0;
    while (i < n) {
      i += 1;
      yield Math.floor(Math.random() * max);
    }
  }

  /**
   * An array of random integers between 0 and 3
   * @type {[!number]}
   */
  const mixedBalls = [...(randomGen(3, 22))];

  /**
   * Sort the given array into 3 sub-arrays and then concatenate those.
   */
  const sortedBalls = mixedBalls
    .reduce((p,c) => p[c].push(c) && p, [[],[],[]])
    .reduce((p,c) => p.concat(c), []);

  /**
   * A verbatim implementation of the Wikipedia pseudo-code
   * @param {!Array<!number>} A
   * @param {!number} mid The value of the 'mid' number. In our case 1 as
   * low is 0 and high is 2
   */
  const dutchSort = (A, mid) => {
    let i = 0;
    let j = 0;
    let n = A.length - 1;
    while(j <= n) {
      if (A[j] < mid) {
        [A[i], A[j]] = [A[j], A[i]];
        i += 1;
        j += 1;
      } else if (A[j] > mid) {
        [A[j], A[n]] = [A[n], A[j]];
        n -= 1
      } else {
        j += 1;
      }
    }
  };

  console.log(`Mixed balls       : ${mixedBalls.map(name).join()}`);
  console.log(`Is sorted: ${isSorted(mixedBalls)}`);

  console.log(`Sorted balls      : ${sortedBalls.map(name).join()}`);
  console.log(`Is sorted: ${isSorted(sortedBalls)}`);

  // Only do the dutch sort now as it mutates the mixedBalls array in place.
  dutchSort(mixedBalls, 1);
  console.log(`Dutch Sorted balls: ${mixedBalls.map(name).join()}`);
  console.log(`Is sorted: ${isSorted(mixedBalls)}`);
};
dutchNationalFlag();
