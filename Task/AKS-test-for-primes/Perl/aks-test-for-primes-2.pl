use ntheory ":all";
# Uncomment next line to see the r and s values used.  Set to 2 for more detail.
# prime_set_config(verbose => 1);
say join(" ", grep { is_aks_prime($_) } 1_000_000_000 .. 1_000_000_100);
