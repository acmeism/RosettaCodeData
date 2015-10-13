my @Q = (0,1,1);
push @Q, $Q[-$Q[-1]] + $Q[-$Q[-2]] for 1..100_000;
say "First 10 terms: [@Q[1..10]]";
say "Term 1000: $Q[1000]";
say "Terms less than preceding in first 100k: ",scalar(grep { $Q[$_] < $Q[$_-1] } 2..100000);
