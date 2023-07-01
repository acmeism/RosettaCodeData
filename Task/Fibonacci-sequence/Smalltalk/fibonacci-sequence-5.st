(10 to:1e6 byFactor:10) do:[:n |
  Transcript printCR:'----',n,'----'.
  Transcript printCR: n fibI.
  Transcript printCR: ([[n fibR] on:RecursionError do:['recursion']] valueWithTimeout:30 seconds) ? 'timeout'.
  Transcript printCR: n fibBinet.
  Transcript printCR: n fibBinetFloatE.
].

Transcript cr; showCR:'Timing:'; showCR:'------'.
[ 1000 fibI ] benchmark:'1000 fibI'.
[ 1000 fibR ] benchmark:'1000 fibR' timeLimit:30 seconds.
[ 1000 fibBinet ] benchmark:'1000 fibBinet'.
[ 1000 fibBinetFloatE] benchmark:'1000 fibBinetFloatE'.
[ 1000 fib ] benchmark:'1000 fib (builtin)'.

[ 10000 fibI ] benchmark:'10000 fibI'.
[ 10000 fib ] benchmark:'10000 fib (builtin)'.

[ 100000 fibI ] benchmark:'100000 fibI'.
[ 100000 fib ] benchmark:'100000 fib (builtin)'.

[ 1000000 fibI ] benchmark:'100000 fibI'.
[ 1000000 fib ] benchmark:'1000000 fib (builtin)'.
[ 2000000 fib ] benchmark:'2000000 fib (builtin)'.
[ 10000000 fib ] benchmark:'10000000 fib (builtin)'
