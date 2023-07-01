last_sundays() {
  local y=$1
  for (( m=1; m<=12; ++m )); do
    cal $m $y | awk -vy=$y -vm=$m '/^.[0-9]/ {d=$1} END {print y"-"m"-"d}'
  done
}
