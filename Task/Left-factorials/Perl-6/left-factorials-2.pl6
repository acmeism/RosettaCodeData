constant leftfact = 0, |[\+] 1, (|[\*] 1..*);

$ = leftfact[10000]; # Pre-initialize

.say for ( 0 … 10, 20 … 110 ).hyper(:4batch).map: { sprintf "!%d  = %s", $_, leftfact[$_] };
.say for (1000, 2000 … 10000).hyper(:4batch).map: { sprintf "!%d has %d digits.", $_, chars leftfact[$_] };
