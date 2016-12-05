echo 1e234 * 1e234 # inf
echo 1e234 * -1e234 # -inf
echo 1 / inf # 0
echo inf + -inf # -nan
echo nan # nan

echo nan == nan # false
echo 0.0 == -0.0 # true
echo 0.0 * nan # nan
echo nan * 0.0 # nan
echo 0.0 * inf # -nan
echo inf * 0.0 # -nan
