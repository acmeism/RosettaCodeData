def count(f): reduce f as $i (0; . + 1);

count( [range(0;20)] | non_continuous_subsequences)
