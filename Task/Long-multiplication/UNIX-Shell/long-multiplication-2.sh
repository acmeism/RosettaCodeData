add() { # arbitrary-precision addition
  local a="$1" b="$2" sum= carry=0
  if (( ${#a} < ${#b} )); then
    local t="$a"
    a="$b" b="$t"
  fi

  while (( ${#a} )); do
    local -i d1="${a##${a%?}}" d2="10#0${b##${b%?}}" s=carry+d1+d2
    sum="${s##${s%?}}$sum"
    carry="10#0${s%?}"
    a="${a%?}" b="${b%?}"
  done
  echo "$sum"
}

multiply() { # arbitrary-precision multiplication
  local a="$1" b="$2" product=0
  if (( ${#a} < ${#b} )); then
    local t="$a"
    a="$b" b="$t"
  fi

  local zeroes=
  while (( ${#b} )); do
    local m1="$a"
    local m2="${b##${b%?}}"
    local partial=$zeroes
    local -i carry=0
    while (( ${#m1} )); do
      local -i d="${m1##${m1%?}}"
      m1="${m1%?}"
      local -i p=d*m2+carry
      partial="${p##${p%?}}$partial"
      carry="10#0${p%?}"
    done
    partial="${carry#0}$partial"
    product="$(add "$product" "$partial")"
    zeroes=0$zeroes
    b="${b%?}"
  done
  echo "$product"
}
