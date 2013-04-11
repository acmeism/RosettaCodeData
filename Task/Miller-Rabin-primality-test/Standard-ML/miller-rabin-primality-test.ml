open LargeInt;

val mr_iterations = Int.toLarge 20;
val rng = Random.rand (557216670, 13504100); (* arbitrary pair to seed RNG *)

fun expmod base 0 m = 1
  | expmod base exp m =
      if exp mod 2 = 0
      then let val rt = expmod base (exp div 2) m;
               val sq = (rt*rt) mod m
           in if sq = 1
                 andalso rt <> 1     (* ignore the two *)
                 andalso rt <> (m-1) (* 'trivial' roots *)
              then 0
              else sq
           end
      else (base*(expmod base (exp-1) m)) mod m;

(* arbitrary precision random number [0,n) *)
fun rand n =
  let val base = Int.toLarge(valOf Int.maxInt)+1;
      fun step r lim =
        if lim < n then step (Int.toLarge(Random.randNat rng) + r*base) (lim*base)
                   else r mod n
  in step 0 1 end;

fun miller_rabin n =
  let fun trial n 0 = true
        | trial n t = let val a = 1+rand(n-1)
                      in (expmod a (n-1) n) = 1
                         andalso trial n (t-1)
                      end
  in trial n mr_iterations end;

fun trylist label lst = (label, ListPair.zip (lst, map miller_rabin lst));

trylist "test the first six Carmichael numbers"
        [561, 1105, 1729, 2465, 2821, 6601];

trylist "test some known primes"
        [7369, 7393, 7411, 27367, 27397, 27407];

(* find ten random 30 digit primes (according to Miller-Rabin) *)
let fun findPrime trials = let val t = trials+1;
                               val n = 2*rand(500000000000000000000000000000)+1
                           in if miller_rabin n
                              then (n,t)
                              else findPrime t end
in List.tabulate (10, fn e => findPrime 0) end;
