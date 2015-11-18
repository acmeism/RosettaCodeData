constant fact = 1, |[\*] 1..*;
constant leftfact = 0, |[\+] fact;

printf "!%d  = %s\n", $_, leftfact[$_] for 0 ... 10, 20 ... 110;
printf "!%d has %d digits.\n", $_, leftfact[$_].chars for 1000, 2000 ... 10000;
