test({N,M}) when N > M -> M;
test({N,M}) when N < M -> N;
test(_) -> equal.
