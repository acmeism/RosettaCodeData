function permute {
  if (( $# == 1 )); then
    set -- $(seq $1)
  fi
  local A=("$@")
  permuteAn "$#"
}

function permuteAn {
  # print all permutations of first n elements of the array A, with remaining
  # elements unchanged.
  local -i n=$1 i
  shift
  if (( n == 1 )); then
    printf '%s\n' "${A[*]}"
  else
    permuteAn $(( n-1 ))
    for (( i=0; i<n-1; ++i )); do
      local -i k
      (( k=n%2 ? 0: i ))
      local t=${A[k]}
      A[k]=${A[n-1]}
      A[n-1]=$t
      permuteAn $(( n-1 ))
    done
  fi
}
