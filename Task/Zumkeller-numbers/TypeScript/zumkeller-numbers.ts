/**
 * return an array of divisors of a number(n)
 * @params {number} n The number to find divisors from
 * @return {number[]} divisors of n
*/
function getDivisors(n: number): number[] {
    //initialize divisors array
    let divisors: number[] = [1, n]
    //loop through all numbers from 2 to sqrt(n)
    for (let i = 2; i*i <= n; i++) {
      // if i is a divisor of n
      if (n % i == 0) {
        // add i to divisors array
        divisors.push(i);
        // quotient of n/i is also a divisor of n
        let j = n/i;
        // if quotient is not equal to i
        if (i != j) {
          // add quotient to divisors array
          divisors.push(j);
        }
      }
    }

    return divisors
  }

  /**
   * return sum of an array of number
   * @param {number[]} arr The array we need to sum
   * @return {number} sum of arr
   */
  function getSum(arr: number[]): number {
    return arr.reduce((prev, curr) => prev + curr, 0)
  }

  /**
   * check if there is a subset of divisors which sums to a specific number
   * @param {number[]} divs The array of divisors
   * @param {number} sum The number to check if there's a subset of divisors which sums to it
   * @return {boolean} true if sum is 0, false if divisors length is 0
   */
  function isPartSum(divs: number[], sum: number): boolean {
    // if sum is 0, the partition is sum up to the number(sum)
    if (sum == 0) return true;
    //get length of divisors array
    let len = divs.length;
    // if divisors array is empty the partion doesnt not sum up to the number(sum)
    if (len == 0) return false;
    //get last element of divisors array
    let last = divs[len - 1];
    //create a copy of divisors array without the last element
    const newDivs = [...divs];
    newDivs.pop();
    // if last element is greater than sum
    if (last > sum) {
      // recursively check if there's a subset of divisors which sums to sum using the new divisors array
      return isPartSum(newDivs, sum);
    }
    // recursively check if there's a subset of divisors which sums to sum using the new divisors array
    // or if there's a subset of divisors which sums to sum - last using the new divisors array
    return isPartSum(newDivs, sum) || isPartSum(newDivs, sum - last);
  }

  /**
   * check if a number is a Zumkeller number
   * @param {number} n The number to check if it's a Zumkeller number
   * @returns {boolean} true if n is a Zumkeller number, false otherwise
   */
  function isZumkeller(n: number): boolean {
    // get divisors of n
    let divs = getDivisors(n);
    // get sum of divisors of n
    let sum = getSum(divs);
    // if sum is odd can't be split into two partitions with equal sums
    if (sum % 2 == 1) return false;
    // if n is odd use 'abundant odd number' optimization
    if (n % 2 == 1) {
      let abundance = sum - 2 * n
      return abundance > 0 && abundance%2 == 0;
    }

    // if n and sum are both even check if there's a partition which totals sum / 2
    return isPartSum(divs, sum/2);
  }

  /**
   * find x zumkeller numbers
   * @param {number} x The number of zumkeller numbers to find
   * @returns {number[]} array of x zumkeller numbers
   */
  function getXZumkelers(x: number): number[] {
    let zumkellers: number[] = [];
    let i = 2;
    let count= 0;
    while (count < x) {
        if (isZumkeller(i)) {
            zumkellers.push(i);
            count++;
        }
        i++;
    }

    return zumkellers;
  }

  /**
   * find x Odd Zumkeller numbers
   * @param {number} x The number of odd zumkeller numbers to find
   * @returns {number[]} array of x odd zumkeller numbers
   */
  function getXOddZumkelers(x: number): number[] {
    let oddZumkellers: number[] = [];
    let i = 3;
    let count = 0;
    while (count < x) {
      if (isZumkeller(i)) {
        oddZumkellers.push(i);
        count++;
      }
      i += 2;
    }

    return oddZumkellers;
  }

  /**
   * find x odd zumkeller number which are not end with 5
   * @param {number} x The number of odd zumkeller numbers to find
   * @returns {number[]} array of x odd zumkeller numbers
   */
  function getXOddZumkellersNotEndWith5(x: number): number[] {
    let oddZumkellers: number[] = [];
    let i = 3;
    let count = 0;
    while (count < x) {
      if (isZumkeller(i) && i % 10 != 5) {
        oddZumkellers.push(i);
        count++;
      }
      i += 2;
    }

    return oddZumkellers;
  }

//get the first 220 zumkeller numbers
console.log("First 220 Zumkeller numbers: ", getXZumkelers(220));

//get the first 40 odd zumkeller numbers
console.log("First 40 odd Zumkeller numbers: ", getXOddZumkelers(40));

//get the first 40 odd zumkeller numbers which are not end with 5
console.log("First 40 odd Zumkeller numbers which are not end with 5: ", getXOddZumkellersNotEndWith5(40));
