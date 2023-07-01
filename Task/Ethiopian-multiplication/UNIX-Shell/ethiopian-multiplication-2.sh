halve() {
  (( $1 >>= 1 ))
}

double() {
  (( $1 <<= 1 ))
}

is_even() {
  (( ($1 & 1) == 0 ))
}

multiply() {
  local plier=$1
  local plicand=$2
  local result=0

  while (( plier > 0 ))
  do
    is_even plier || (( result += plicand ))
    halve plier
    double plicand
  done
  echo $result
}

multiply 17 34
# => 578
