# 20210325 Raku programming solution

my @multiplier = ( 1, 3, 5, 7, 11, 3*5, 3*7, 3*11, 5*7, 5*11, 7*11, 3*5*7, 3*5*11, 3*7*11, 5*7*11, 3*5*7*11 );

sub circumfix:<⌊ ⌋>{ $^n.floor }; sub prefix:<√>{ $^n.sqrt }; # just for fun

sub SQUFOF ( \𝑁 ) {

   return  1 if 𝑁.is-prime;     # if n is prime             return  1
   return √𝑁 if √𝑁 == Int(√𝑁);  # if n is a perfect square  return √𝑁

   for @multiplier -> \𝑘 {
      my \Pₒ = $ = ⌊ √(𝑘*𝑁) ⌋;          # P[0]=floor(√N)
      my \Qₒ = $ = 1 ;                  # Q[0]=1
      my \Q = $ =  𝑘*𝑁 - Pₒ²;           # Q[1]=N-P[0]^2 & Q[i]
      my \Pₚᵣₑᵥ = $ = Pₒ;               # P[i-1] = P[0]
      my \Qₚᵣₑᵥ = $ = Qₒ;               # Q[i-1] = Q[0]
      my \P = $ = 0;                    # P[i]
      my \Qₙₑₓₜ = $ = 0;                # P[i+1]
      my \b = $ = 0;                    # b[i]
                                        # i = 1
      repeat until √Q == Int(√Q) {      # until Q[i] is a perfect square
         b = ⌊⌊ √(𝑘*𝑁) + Pₚᵣₑᵥ ⌋ / Q ⌋;    # floor(floor(√N+P[i-1])/Q[i])
         P = b*Q - Pₚᵣₑᵥ;                  # P[i]=b*Q[i]-P[i-1]
         Qₙₑₓₜ = Qₚᵣₑᵥ + b*(Pₚᵣₑᵥ - P);    # Q[i+1]=Q[i-1]+b(P[i-1]-P[i])
         ( Qₚᵣₑᵥ,  Q, Pₚᵣₑᵥ ) = Q, Qₙₑₓₜ, P;  # i++
      }

      b     = ⌊ ⌊ √(𝑘*𝑁)+P ⌋ / Q ⌋;     # b=floor((floor(√N)+P[i])/Q[0])
      Pₚᵣₑᵥ = b*Qₒ - P;                 # P[i-1]=b*Q[0]-P[i]
      Q     = ( 𝑘*𝑁 - Pₚᵣₑᵥ² )/Qₒ;      # Q[1]=(N-P[0]^2)/Q[0] & Q[i]
      Qₚᵣₑᵥ = Qₒ;                       # Q[i-1] = Q[0]
                                        # i = 1
      loop {                            # repeat
         b  = ⌊ ⌊ √(𝑘*𝑁)+Pₚᵣₑᵥ ⌋ / Q ⌋;    # b=floor(floor(√N)+P[i-1])/Q[i])
         P  = b*Q - Pₚᵣₑᵥ;                 # P[i]=b*Q[i]-P[i-1]
         Qₙₑₓₜ = Qₚᵣₑᵥ + b*(Pₚᵣₑᵥ - P);    # Q[i+1]=Q[i-1]+b(P[i-1]-P[i])
         last if (P == Pₚᵣₑᵥ);          # until P[i+1]=P[i]
         ( Qₚᵣₑᵥ,  Q, Pₚᵣₑᵥ ) = Q, Qₙₑₓₜ, P; # i++
      }
      given 𝑁 gcd P { return $_ if $_ != 1|𝑁 }
   }  # gcd(N,P[i]) (if != 1 or N) is a factor of N, otherwise try next k
   return 0 # give up
}

race for (
   11111, # wikipedia.org/wiki/Shanks%27s_square_forms_factorization#Example
   4558849, # example from talk page
   # all of the rest are taken from the FreeBASIC entry
   2501,12851,13289,75301,120787,967009,997417,7091569,13290059,
   42854447,223553581,2027651281,11111111111,100895598169,1002742628021,
   # time hoarders
   60012462237239, # = 6862753 * 8744663                     15s
   287129523414791, # = 6059887 * 47381993                   80s
   11111111111111111, # = 2071723 * 5363222357                2m
   384307168202281507, # = 415718707 * 924440401              5m
   1000000000000000127, # = 111756107 * 8948056861           12m
   9007199254740931, # = 10624181 * 847801751                17m
   922337203685477563, # = 110075821 * 8379108103            41m
   314159265358979323, # = 317213509 * 990371647             61m
   1152921505680588799, # = 139001459 * 8294312261           93m
   658812288346769681, # = 62222119 * 10588072199           112m
   419244183493398773, # = 48009977 * 8732438749            135m
   1537228672809128917, # = 26675843 * 57626245319          254m
   # don't know how to handle this one
   # for 1e-323, 1e-324 { my $*TOLERANCE = $_ ;
   #     say 4611686018427387877.sqrt ≅ 4611686018427387877.sqrt.Int }
   # skip the perfect square check and start k with 3 to get the following
   # 4611686018427387877, # = 343242169 * 13435662733       217m
) -> \data {
   given data.&SQUFOF {
      when 0  { say "The number ", data, " is not factored." }
      when 1  { say "The number ", data, " is a prime." }
      default { say data, " = ", $_, " * ", data div $_.Int }
   }
}
