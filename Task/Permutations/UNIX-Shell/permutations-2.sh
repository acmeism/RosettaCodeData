function permuteAn {
  # print all permutations of first n elements of the array A, with remaining
  # elements unchanged.
  local -i n=$1 i
  shift
  if (( n == 1 )); then
    printf '%s\n' "${A[*]}"
  else
    permuteAn $(( n-1 ))
    for (( i=1; i<n; ++i )); do
      local -i k
      (( k=n%2 ? 1 : i ))
      local t=$A[k]
      A[k]=$A[n]
      A[n]=$t
      permuteAn $(( n-1 ))
    done
  fi
}
