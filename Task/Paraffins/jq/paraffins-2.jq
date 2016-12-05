def paraffins:
  foreach range(1; MAX_N) as $n
    ( [unrooted, ra];
      tree(0; $n; $n; 1; 1) | bicenter($n);
      [$n, .[0][$n]]
    )
;
