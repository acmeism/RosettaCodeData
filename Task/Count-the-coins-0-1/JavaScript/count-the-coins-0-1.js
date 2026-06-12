// Helper function to print arrays
function printArray(arr) {
  console.log(`[${arr.join(", ")}]`);
}

// Generate all permutations of an array
function permutations(arr) {
  const result = [];

  // Helper function to generate permutations
  function generatePermutations(current, remaining) {
    if (remaining.length === 0) {
      result.push([...current]);
      return;
    }

    for (let i = 0; i < remaining.length; i++) {
      const newRemaining = [...remaining];
      const element = newRemaining.splice(i, 1)[0];

      current.push(element);
      generatePermutations(current, newRemaining);
      current.pop();
    }
  }

  generatePermutations([], [...arr]);
  return result;
}

// Generate combinations of k elements from the array
function combinations(arr, k) {
  const result = [];

  // Helper function to generate combinations
  function generateCombinations(start, current) {
    if (current.length === k) {
      result.push([...current]);
      return;
    }

    for (let i = start; i < arr.length; i++) {
      current.push(arr[i]);
      generateCombinations(i + 1, current);
      current.pop();
    }
  }

  generateCombinations(0, []);
  return result;
}

// Generate all combinations of any length from the array
function allCombinations(arr) {
  const result = [];

  for (let i = 1; i <= arr.length; i++) {
    const combs = combinations(arr, i);
    result.push(...combs);
  }

  return result;
}

// Count coin combinations and permutations that sum to target
function countCoins(coins, target) {
  console.log(`Coins are [${coins.join(", ")}], target sum is ${target}`);

  let combCount = 0;
  let permCount = 0;

  const allCombs = allCombinations(coins);

  for (const combination of allCombs) {
    const sum = combination.reduce((acc, val) => acc + val, 0);

    if (sum === target) {
      combCount += 1;

      if (target <= 6) {
        process.stdout.write(`[${combination.join(", ")}] sums to ${target}\n`);
      }

      const perms = permutations(combination);

      for (const permutation of perms) {
        if (target <= 6) {
          process.stdout.write(`    permutation: [${permutation.join(", ")}]\n`);
        }
        permCount += 1;
      }
    }
  }

  console.log(`Combinations: ${combCount}, Permutations: ${permCount}`);
  console.log();
}

// Main function
function main() {
  countCoins([1, 2, 3, 4, 5], 6);
  countCoins([1, 1, 2, 3, 3, 4, 5], 6);
  countCoins([1, 2, 3, 4, 5, 5, 5, 5, 15, 15, 10, 10, 10, 10, 25, 100], 40);
}

// Run the main function
main();
