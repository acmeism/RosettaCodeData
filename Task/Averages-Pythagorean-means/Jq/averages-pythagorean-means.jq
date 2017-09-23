def amean: add/length;

def logProduct: map(log) | add;

def gmean:  (logProduct / length) | exp;

def hmean: length / (map(1/.) | add);

# Tasks:
 [range(1;11) ] | [amean, gmean, hmean] as $ans
 | ( $ans[],
   "amean > gmean > hmean => \($ans[0] > $ans[1] and $ans[1] > $ans[2] )" )
