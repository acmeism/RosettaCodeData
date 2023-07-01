def MAX_N: 500;  # imprecision begins at 46
def BRANCH: 4;

# state: [unrooted, ra]
# tree(br; n; l; sum; cnt) where initially: l=n, sum=1 and cnt=1
def tree(br; n; l; sum; cnt):

  # The inner function is used to implement the range(b+1; BRANCH) loop
  # as there are early exits.
  # On completion, _tree returns [unrooted, ra]
  def _tree: # state [ (b, c, sum),  (unrooted, ra)]
    if length != 5 then error("_tree input has length \(length)") else . end
    | .[0] as $b | .[1] as $c | .[2] as $sum | .[3] as $unrooted | .[4] as $ra
    | if $b > BRANCH then [$unrooted, $ra]
      else
        ($sum + n) as $sum
        | if $sum >= MAX_N or
             # prevent unneeded long math
             ( l * 2 >= $sum and $b >= BRANCH) then [$unrooted, $ra]                      # return
          else (if $b == br + 1 then $ra[n] * cnt
                else ($c * ($ra[n] + (($b - br - 1)))) / ($b - br) | floor
                end) as $c
          | (if l * 2 < $sum then ($unrooted | .[$sum] += $c)
             else $unrooted end) as $unrooted
          | if $b >= BRANCH then [$b+1, $c, $sum, $unrooted, $ra] | _tree                 # next
            else  [$unrooted, ($ra | .[$sum] += $c) ]
            | reduce range(1; n) as $m (.;  tree($b; $m; l; $sum; $c))
            | ([$b + 1, $c, $sum] + .) | _tree
            end
          end
      end
  ;

  # start by incrementing b, and prepending values for (b,c,sum)
  ([br+1, cnt, sum] + .)  | _tree
;

# input and output: [unrooted, ra]
def bicenter(s):
  if s % 2 == 1 then .
  else
     .[1][s / 2] as $aux
     | .[0][s] += ($aux * ($aux + 1)) / 2 # 2 divides odd*even
  end
;

def array(n;init): [][n-1] = init | map(init);

def ra: array( MAX_N; 0) | .[0] = 1 | .[1] = 1;

def unrooted: ra;

# See below for a simpler implementation using "foreach"
def paraffins:
  # range(1; MAX_N)
  def _paraffins(n):
    if n >= MAX_N then empty
    else tree(0; n; n; 1; 1) | bicenter(n)
    | [n, .[0][n]],  # output
      _paraffins(n+1)
    end;
  [unrooted, ra] | _paraffins(1)
;

paraffins
