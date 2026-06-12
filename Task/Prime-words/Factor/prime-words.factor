USING: io.encodings.ascii io.files math.primes prettyprint sequences ;

"unixdict.txt" ascii file-lines [ [ prime? ] all? ] filter .
