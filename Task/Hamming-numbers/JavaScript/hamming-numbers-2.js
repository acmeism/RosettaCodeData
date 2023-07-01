<html>
<head></head>
<body>
    <div id="main"></div>
</body>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="http://peterolson.github.com/BigInteger.js/BigInteger.min.js"></script>
<script type="text/javascript">
    var _primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37];

    function log(text) {
        $('#main').append(text + "\n");
    }

    function big(exponents) {
        var i, e, val = bigInt.one;
        for (i = 0; i < exponents.length; i++)
            for (e = 0; e < exponents[i]; e++)
                val = val.times(_primes[i]);
        return val.toString();
    }

    function hamming(n, nprimes) {
        var i, iter, p, q, min, equal, x;

        var hammings = new Array(n);                            // array of hamming #s we generate
        hammings[0] = new Array(nprimes);
        for (p = 0; p < nprimes; p++) {
            hammings[0][p] = 0;
        }

        var hammlogs = new Array(n);                            // log values for above
        hammlogs[0] = 0;

        var primelogs = new Array(nprimes);                     // pre-calculated prime log values
        var listlogs  = new Array(nprimes);                     // log values of list heads
        for (p = 0; p < nprimes; p++) {
            primelogs[p] = listlogs[p] = Math.log(_primes[p]);
        }

        var indexes = new Array(nprimes);                       // intermediate hamming values as indexes into hammings
        for (p = 0; p < nprimes; p++) {
            indexes[p] = 0;
        }

        var listheads = new Array(nprimes);                     // intermediate hamming list heads
        for (p = 0; p < nprimes; p++) {
            listheads[p] = new Array(nprimes);
            for (q = 0; q < nprimes; q++) {
                listheads[p][q] = 0;
            }
            listheads[p][p] = 1;
        }

        for (iter = 1; iter < n; iter++) {
            min = 0;
            for (p = 1; p < nprimes; p++)
                if (listlogs[p] < listlogs[min])
                    min = p;
            hammlogs[iter] = listlogs[min];                     // that's the next hamming number
            hammings[iter] = listheads[min].slice();
            for (p = 0; p < nprimes; p++) {                     // update each list head if it matches new value
                equal = true;                                   // test each exponent to see if number matches
                for (i = 0; i < nprimes; i++) {
                    if (hammings[iter][i] != listheads[p][i]) {
                        equal = false;
                        break;
                    }
                }
                if (equal) {                                    // if it matches...
                    x = ++indexes[p];                           // set index to next hamming number
                    listheads[p] = hammings[x].slice();         // copy hamming number
                    listheads[p][p] += 1;                       // increment exponent = mult by prime
                    listlogs[p] = hammlogs[x] + primelogs[p];   // add log(prime) to log(value) = mult by prime
                }
            }
        }

        return hammings[n - 1];
    }

    $(document).ready(function() {
        var i, nprimes;
        var t = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,1691,1000000];

        for (nprimes = 3; nprimes <= 4; nprimes++) {
            var start = new Date();
            log('<h1>' + _primes[nprimes - 1] + '-Smooth:' + '</h1>');
            log('<table>');
            for (i = 0; i < t.length; i++)
                log('<tr>' + '<td>' + t[i] + ':' + '</td><td>' + big(hamming(t[i], nprimes)) + '</td>');
            var end = new Date();
            log('<tr>' + '<td>' + 'Elapsed time:' + '</td><td>' + (end-start)/1000 + ' seconds' +  '</td>');
            log('</table>');
        }
    });
</script>
</html>
