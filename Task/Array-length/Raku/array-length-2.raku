my @infinite = 1 .. Inf;  # 1, 2, 3, 4, ...

say @infinite[5000];  # 5001
say @infinite.elems;  # Throws exception "Cannot .elems a lazy list"
