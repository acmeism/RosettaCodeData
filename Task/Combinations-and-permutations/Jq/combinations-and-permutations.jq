def permutation(k): . as $n
  | reduce range($n-k+1; 1+$n) as $i (1; . * $i);

def combination(k): . as $n
  | if k > ($n/2) then combination($n-k)
    else reduce range(0; k) as $i (1; (. * ($n - $i)) / ($i + 1))
    end;

# natural log of n!
def log_factorial: (1+.) | tgamma | log;

def log_permutation(k):
  (log_factorial - ((.-k) | log_factorial));

def log_combination(k):
  (log_factorial - ((. - k)|log_factorial) - (k|log_factorial));

def big_permutation(k): log_permutation(k) | exp;

def big_combination(k): log_combination(k) | exp;
