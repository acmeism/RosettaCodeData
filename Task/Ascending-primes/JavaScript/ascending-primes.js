<!DOCTYPE html>
<html>
<body>
  <noscript>
    No script, no fun. Turn on Javascript on.
  </noscript>

  <script>
  (()=>{

    function isPrime(n) {
      if (n == 2)
          return true;
      if (n == 1 || n % 2 == 0)
          return false;
      root = Math.sqrt(n)
      for (let k = 3; k <= root; k += 2)
          if (n % k == 0)
              return false;
      return true;
    }

    let queue = [];
    let primes = [];

    for (let k = 1; k <= 9; k++)
      queue.push(k);

    while (queue.length != 0)
    {
        let n = queue.shift();
        if (isPrime(n))
          primes.push(n);
        for (let k = n % 10 + 1; k <= 9; k++)
          queue.push(n * 10 + k);
    }

    document.writeln(primes);

  })();
  </script>

</body>
</html>
