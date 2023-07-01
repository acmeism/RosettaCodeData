BEGIN {  ULIMIT=100

for ( n=1 ; (n++) < ULIMIT ; )
    if (n in S) {
        p = S[n]
        delete S[n]
        for ( m = n ; (m += p) in S ; )  { }
        S[m] = p
        }
    else  print ( S[(n+n)] = n )
}
