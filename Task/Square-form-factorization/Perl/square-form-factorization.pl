use strict;
use warnings;
use feature 'say';
use ntheory <is_prime gcd forcomb vecprod>;

my @multiplier;
my @p = <3 5 7 11>;
forcomb { push @multiplier, vecprod @p[@_] } scalar @p;

sub sff {
   my($N) = shift;
   return 1 if is_prime $N;                    # if n is prime
   return sqrt $N if sqrt($N) == int sqrt $N;  # if n is a perfect square

   for my $k (@multiplier) {
      my $P0 = int sqrt($k*$N);  # P[0]=floor(sqrt(N)
      my $Q0 = 1;                # Q[0]=1
      my $Q  = $k*$N - $P0**2;   # Q[1]=N-P[0]^2 & Q[i]
      my $P1 = $P0;              # P[i-1] = P[0]
      my $Q1 = $Q0;              # Q[i-1] = Q[0]
      my $P  = 0;                # P[i]
      my $Qn = 0;                # $P[$i+1];
      my $b  = 0;                # b[i]

      until (sqrt($Q) == int(sqrt($Q))) {           # until Q[i] is a perfect square
         $b = int( int(sqrt($k*$N) + $P1 ) / $Q);   # floor(floor(sqrt(N+P[i-1])/Q[i])
         $P = $b*$Q - $P1;                          # P[i]=b*Q[i]-P[i-1]
         $Qn = $Q1 + $b*($P1 - $P);                 # Q[i+1]=Q[i-1]+b(P[i-1]-P[i])
         ($Q1, $Q, $P1) = ($Q, $Qn, $P);
      }

      $b  = int( int( sqrt($k*$N)+$P ) / $Q );      # b=floor((floor(sqrt(N)+P[i])/Q[0])
      $P1 = $b*$Q0 - $P;                            # P[i-1]=b*Q[0]-P[i]
      $Q  = ( $k*$N - $P1**2 )/$Q0;                 # Q[1]=(N-P[0]^2)/Q[0] & Q[i]
      $Q1 = $Q0;                                    # Q[i-1] = Q[0]

      while () {
         $b  = int( int(sqrt($k*$N)+$P1  ) / $Q );  # b=floor(floor(sqrt(N)+P[i-1])/Q[i])
         $P  = $b*$Q - $P1;                         # P[i]=b*Q[i]-P[i-1]
         $Qn = $Q1 + $b*($P1 - $P);                 # Q[i+1]=Q[i-1]+b(P[i-1]-P[i])
         last if $P == $P1;                         # until P[i+1]=P[i]
         ($Q1, $Q, $P1) = ($Q, $Qn, $P);
      }
      for (gcd $N, $P) { return $_ if $_ != 1 and $_ != $N }
   }
   return 0
}

for my $data (
   11111, 2501, 12851, 13289, 75301, 120787, 967009, 997417,  4558849,  7091569, 13290059,
   42854447, 223553581, 2027651281, 11111111111, 100895598169, 1002742628021, 60012462237239,
   287129523414791, 11111111111111111, 384307168202281507, 1000000000000000127, 9007199254740931,
   922337203685477563, 314159265358979323, 1152921505680588799, 658812288346769681,
   419244183493398773, 1537228672809128917) {
   my $v = sff($data);
   if    ($v == 0) { say 'The number ' . $data . ' is not factored.' }
   elsif ($v == 1) { say 'The number ' . $data . ' is a prime.'      }
   else            { say "$data = " . join ' * ', sort {$a <=> $b} $v, int $data/int($v) }
}
