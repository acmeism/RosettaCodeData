set -A collection "first" "second" "third" "fourth" "something else"
for x in "${collection[@]}"; do
  echo "$x"
done
