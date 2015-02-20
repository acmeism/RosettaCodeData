use Memoize;  memoize('ack2');
use bigint try=>"GMP";

sub ack2 {
   my ($m, $n) = @_;
   $m == 0 ? $n + 1 :
   $m == 1 ? $n + 2 :
   $m == 2 ? 2*$n + 3 :
   $m == 3 ? 8 * (2**$n - 1) + 5 :
   $n == 0 ? ack2($m-1, 1)
           : ack2($m-1, ack2($m, $n-1));
}
print "ack2(3,4) is ", ack2(3,4), "\n";
print "ack2(4,1) is ", ack2(4,1), "\n";
print "ack2(4,2) has ", length(ack2(4,2)), " digits\n";
