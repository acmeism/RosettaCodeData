function printVector(vec) {
  console.log(vec.join(" "));
}

function factorial(number) {
  if (number > 20) {
    throw new Error("Too large for 64 bit number: " + number);
  }
  if (number < 2) {
    return 1n;
  }

  let result = 1n;
  for (let i = 2; i <= number; ++i) {
    result *= BigInt(i);
  }
  return result;
}

function binomial(n, k) {
  return factorial(n) / factorial(n - k) / factorial(k);
}

function forward(vec) {
  const transform = Array(vec.length).fill(0);
  for (let n = 0; n < vec.length; ++n) {
    for (let k = 0; k <= n; ++k) {
      transform[n] += Number(binomial(n, k)) * vec[k];
    }
  }
  return transform;
}

function inverse(vec) {
  const transform = Array(vec.length).fill(0);
  for (let n = 0; n < vec.length; ++n) {
    for (let k = 0; k <= n; ++k) {
      const sign = ((n - k) & 1) ? -1 : 1;
      transform[n] += Number(binomial(n, k)) * vec[k] * sign;
    }
  }
  return transform;
}

function selfInverting(vec) {
  const transform = Array(vec.length).fill(0);
  for (let n = 0; n < vec.length; ++n) {
    for (let k = 0; k <= n; ++k) {
      const sign = (k & 1) ? -1 : 1;
      transform[n] += Number(binomial(n, k)) * vec[k] * sign;
    }
  }
  return transform;
}

function main() {
  const sequences = [
    [1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845],
    [0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0],
    [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181],
    [1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37]
  ];

  const names = [
    "Catalan number sequence:",
    "Prime flip-flop sequence:",
    "Fibonacci number sequence:",
    "Padovan number sequence:"
  ];

  for (let i = 0; i < sequences.length; ++i) {
    console.log(names[i]);
    printVector(sequences[i]);
    console.log("\nForward binomial transform:");
    printVector(forward(sequences[i]));
    console.log("\nInverse binomial transform:");
    printVector(inverse(sequences[i]));
    console.log("\nRound trip:");
    printVector(inverse(forward(sequences[i])));
    console.log("\nSelf-inverting:");
    printVector(selfInverting(sequences[i]));
    console.log("\nRound trip self-inverting:");
    printVector(selfInverting(selfInverting(sequences[i])));
    console.log("\n");
  }
}

main();
