echo 1e234 * 1e234 # inf
echo 1e234 * -1e234 # -inf
echo 1 / Inf # 0
echo Inf + -Inf # nan
echo NaN # nan

echo NaN == NaN # false
echo 0.0 == -0.0 # true
echo 0.0 * NaN # nan
echo NaN * 0.0 # nan
echo 0.0 * Inf # nan
echo Inf * 0.0 # nan
