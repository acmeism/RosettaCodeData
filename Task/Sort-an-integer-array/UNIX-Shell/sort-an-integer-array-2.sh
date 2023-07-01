set -A nums 2 4 3 1 5
set -A sorted $(printf "%s\n" ${nums[*]} | sort -n)
echo ${sorted[*]}  # prints 1 2 3 4 5
