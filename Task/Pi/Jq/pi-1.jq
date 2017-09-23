# The Gibbons spigot, in the mold of the [[#Groovy]] and ython]] programs shown on this page.
# The "bigint" functions
needed are: long_minus long_add long_multiply long_div

def pi_spigot:

  # S is the sixtuple:
  # q      r      t      k      n      l
  # 0      1      2      3      4      5

  def long_lt(x;y): if x == y then false else lessOrEqual(x;y) end;

  def check:
     long_lt(long_minus(long_add(long_multiply("4"; .[0]); .[1]) ; .[2]);
             long_multiply(.[4]; .[2]));

  # state: [d, S] where digit is null or a digit ready to be printed
  def next:
    .[1] as $S
    | $S[0] as $q | $S[1] as $r | $S[2] as $t | $S[3] as $k | $S[4] as $n | $S[5] as $l
    | if $S|check
      then [$n,
             [long_multiply("10"; $q),
              long_multiply("10"; long_minus($r; long_multiply($n;$t))),
              $t,
              $k,
              long_minus( long_div(long_multiply("10";long_add(long_multiply("3"; $q); $r)); $t );
                          long_multiply("10";$n)),
              $l ]]
      else [null,
             [long_multiply($q;$k),
              long_multiply( long_add(long_multiply("2";$q); $r); $l),
              long_multiply($t;$l),
              long_add($k; "1"),
              long_div( long_add(long_multiply($q; long_add(long_multiply("7";$k); "2")) ; long_multiply($r;$l));
                        long_multiply($t;$l) ),
              long_add($l; "2") ]]
      end;

  # Input: input to the filter "nextstate"
  # Output:  [count, space, digit] for successive digits produced by "nextstate"
  def decorate( nextstate ):

     # For efficiency it is important that the recursive
     # function have arity 0 and be tail-recursive:
     def count:
       .[0] as $count
       | .[1] as $state
       | $state[0] as $value
       | ($state[1] | map(length) | add) as $space
       | (if $value then [$count, $space, $value] else empty end),
         ( [if $value then $count+1 else $count end, ($state | nextstate)] | count);
  [0, .] | count;

  #       q=1, r=0, t=1, k=1, n=3, l=3
  [null, ["1", "0", "1", "1", "3", "3"]] | decorate(next)
;

pi_spigot
