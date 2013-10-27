proc gcd_recursive(u, v: int64): int64 =
    if u %% v != 0:
        result = gcd_recursive(v, u %% v)
    else:
        result = v
