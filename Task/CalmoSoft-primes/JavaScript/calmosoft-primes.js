class PrimeGenerator {
  constructor(min, max) {
    this.min = min || 2;
    this.max = max || Number.MAX_SAFE_INTEGER;
    this.current = this.min - 1;
  }

  nextPrime() {
    let candidate = this.current + 1;
    while (!isPrime(candidate) || candidate > this.max) {
      candidate++;
      if (candidate > this.max) return Infinity;
    }
    this.current = candidate;
    return candidate;
  }
}

function isPrime(n) {
  if (n < 2) return false;
  if (n % 2 === 0) return n === 2;
  if (n % 3 === 0) return n === 3;
  for (let p = 5; p * p <= n; p += 4) {
    if (n % p === 0) return false;
    p += 2;
    if (n % p === 0) return false;
  }
  return true;
}

function join(separator, list) {
  return list.map(item => item.toString()).join(separator);
}

function calmoSoftPrimes() {
  const primeGen = new PrimeGenerator(100000, 250000);
  const primes = [];
  const limits = [100, 5000, 10000, 500000, 50000000];
  let total = 0;
  let last = 0;
  let prime = primeGen.nextPrime();

  for (const limit of limits) {
    do {
      primes.push(prime);
      total += prime;
      ++last;
      prime = primeGen.nextPrime();
    } while (prime < limit);

    let sum = total;
    let longest = 1;
    let starts = [];

    for (let start = 0; start <= last - longest; ++start) {
      let s = sum;
      for (let finish = last; finish-- >= start + longest;) {
        if (isPrime(s)) {
          const length = finish - start + 1;
          if (length > longest) {
            longest = length;
            starts = [];
          }
          starts.push(start);
        }
        s -= primes[finish];
      }
      sum -= primes[start];
    }

    console.log(`For primes up to ${limit}:\nThe following sequence${starts.length === 1 ? "" : "s"} of ${longest} consecutive primes yield${starts.length === 1 ? "s" : ""} a prime sum:`);

    for (let i = 0; i < starts.length; ++i) {
      const start = starts[i];
      sum = 0;
      for (let j = start; j < start + longest; ++j) {
        sum += primes[j];
      }

      const separator = " + ";
      if (longest > 12) {
        console.log(
          join(separator, primes.slice(start, start + 6)) +
          separator + "..." + separator +
          join(separator, primes.slice(start + longest - 6, start + longest)) +
          " = " + sum
        );
      } else {
        console.log(
          join(separator, primes.slice(start, start + longest)) +
          " = " + sum
        );
      }
    }

    console.log();
  }
}

calmoSoftPrimes();
