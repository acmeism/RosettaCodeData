declare -i len=${1:-10}
balls=()
while (( ${#balls[@]} < len )) || dutch? "${balls[@]}"; do
  balls=($(random_balls "$len"))
done
echo "Initial list: ${balls[@]}"
balls=($(dutch "${balls[@]}"))
echo "Sorted: ${balls[@]}"
