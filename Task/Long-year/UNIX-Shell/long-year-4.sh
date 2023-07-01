for y in $(seq 1995 2045); do
  if long_year $y; then
    echo $y
  fi
done | column
