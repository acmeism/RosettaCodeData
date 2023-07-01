function faro {
   if (( $# % 2 )); then
     printf >&2 'Can only shuffle an even number of elements!\n'
     return 1
   fi
   typeset -i half=$(($#/2)) i
   typeset argv=("$@")
   for (( i=0; i<half; ++i )); do
     printf '%s\n%s\n' "${argv[i${ZSH_VERSION:++1}]}" "${argv[i+half${ZSH_VERSION:++1}]}"
   done
}

function count_faros {
  typeset argv=("$@")
  typeset -i count=0
  argv=($(faro "${argv[@]}"))
  (( count += 1 ))
  while [[ "${argv[*]}" != "$*" ]]; do
    argv=($(faro "${argv[@]}"))
    (( count += 1 ))
  done
  printf '%d\n' "$count"
}

# Include time taken, which is combined from the three shells in the output below
printf '%s\t%s\t%s\n' Size Shuffles Seconds
for size in 8 24 52 100 1020 1024 10000; do
    eval "array=({1..$size})"
    start=$(date +%s)
    count=$(count_faros "${array[@]}")
    taken=$(( $(date +%s) - start ))
    printf '%d\t%d\t%d\n' "$size" "$count" "$taken"
done
