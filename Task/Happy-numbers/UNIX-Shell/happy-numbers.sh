function sum_of_square_digits {
  typeset -i n=$1 sum=0 d
  while (( n )); do
    (( d=n%10, sum+=d*d, n=n/10 ))
  done
  printf '%d\n' "$sum"
}

function is_happy {
   typeset -i n=$1
   typeset -a seen=()
   while (( n != 1 )); do
     if [[ -n ${seen[$n]} ]]; then
        return 1
     fi
     seen[$n]=1
     (( n=$(sum_of_square_digits "$n") ))
   done
   return 0
}

function first_n_happy {
  typeset -i count=$1 n
  for (( n=1; count; n+=1 )); do
    if is_happy "$n"; then
      printf '%d\n' "$n"
      (( count -= 1 ))
    fi
  done
  return 0
}

first_n_happy 8
