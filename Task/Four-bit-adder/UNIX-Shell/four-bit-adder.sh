xor() {
  typeset -i a=$1 b=$2
  printf '%d\n' $(( (a || b)  && ! (a && b) ))
}

half_adder() {
  typeset -i a=$1 b=$2
  printf '%d %d\n' $(xor $a $b) $(( a && b ))
}

full_adder() {
  typeset -i a=$1 b=$2 c=$3
  typeset -i ha0_s ha0_c ha1_s ha1_c
  read ha0_s ha0_c < <(half_adder "$c" "$a")
  read ha1_s ha1_c < <(half_adder "$ha0_s" "$b")
  printf '%d %d\n' "$ha1_s" "$(( ha0_c || ha1_c ))"
}

four_bit_adder() {
  typeset -i a0=$1 a1=$2 a2=$3 a3=$4 b0=$5 b1=$6 b2=$7 b3=$8
  typeset -i fa0_s fa0_c fa1_s fa1_c fa2_s fa2_c fa3_s fa3_c
  read fa0_s fa0_c < <(full_adder "$a0" "$b0" 0)
  read fa1_s fa1_c < <(full_adder "$a1" "$b1" "$fa0_c")
  read fa2_s fa2_c < <(full_adder "$a2" "$b2" "$fa1_c")
  read fa3_s fa3_c < <(full_adder "$a3" "$b3" "$fa2_c")
  printf '%s' "$fa0_s"
  printf ' %s' "$fa1_s" "$fa2_s" "$fa3_s" "$fa3_c"
  printf '\n'
}

is() {
  typeset label=$1
  shift
  if eval "$*"; then
    printf 'ok'
  else
    printf 'not ok'
  fi
  printf ' %s\n' "$label"
}

is "1 + 1 =  2"       "[[ '$(four_bit_adder 1 0 0 0 1 0 0 0)' == '0 1 0 0 0' ]]"
is "5 + 5 = 10"       "[[ '$(four_bit_adder 1 0 1 0 1 0 1 0)' == '0 1 0 1 0' ]]"
is "7 + 9 = overflow" "a=($(four_bit_adder 1 0 0 1 1 1 1 0)); (( \${a[-1]}==1 ))"
