sub prefix:<!> ($k) { (constant l = 0, |[\+] 1, (|[\*] 1..*))[$k] }

$ = !10000; # Pre-initialize

.say for ( 0 … 10, 20 … 110 ).hyper(:4batch).map: { sprintf "!%d  = %s", $_, !$_ };
.say for (1000, 2000 … 10000).hyper(:4batch).map: { sprintf "!%d has %d digits.", $_, chars !$_ };
