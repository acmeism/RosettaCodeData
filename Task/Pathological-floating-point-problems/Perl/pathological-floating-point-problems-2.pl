use bignum qw(bexp);
$e       = bexp(1,43);
$years   = 25;
$balance = $e - 1;

print "Starting balance, \$(e-1): \$$balance\n";
for $i (1..$years) { $balance = $i * $balance - 1 }
printf "After year %d, you will have \$%1.15g in your account.\n", $years, $balance;
