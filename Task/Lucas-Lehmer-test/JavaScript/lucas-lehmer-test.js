////////// In JavaScript we don't have sqrt for BigInt - so here is implementation
    function newtonIteration(n, x0) {
        const x1 = ((n / x0) + x0) >> 1n;
        if (x0 === x1 || x0 === (x1 - 1n)) {
            return x0;
        }
        return newtonIteration(n, x1);
    }

    function sqrt(value) {
        if (value < 0n) {
            throw 'square root of negative numbers is not supported'
        }

        if (value < 2n) {
            return value;
        }
        return newtonIteration(value, 1n);
    }
////////// End of sqrt implementation

    function isPrime(p) {
        if (p == 2n) {
            return true;
        } else if (p <= 1n || p % 2n === 0n) {
            return false;
        } else {
            var to = sqrt(p);
            for (var i = 3n; i <= to; i += 2n)
            if (p % i == 0n) {
                return false;
            }
            return true;
        }
    }

    function isMersennePrime(p) {
        if (p == 2n) {
            return true;
        } else {
            var m_p = (1n << p) - 1n;
            var s = 4n;
            for (var i = 3n; i <= p; i++) {
                s = (s * s - 2n) % m_p;
            }
            return s === 0n;
        }
    }

    var  upb = 5000;
    var tm = Date.now();
    console.log(`Finding Mersenne primes in M[2..${upb}]:`);
    console.log('M2');
    for (var p = 3n; p <= upb; p += 2n){
        if (isPrime(p) && isMersennePrime(p)) {
            console.log("M" + p);
        }
    }
    console.log(`... Took: ${Date.now()-tm} ms`);
