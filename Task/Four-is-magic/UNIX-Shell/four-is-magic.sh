#!/usr/bin/env bash
name_of() {
  # return the English name for a numeric value
  local -i n=$1

  if (( n < 0 )); then
    printf 'negative %s\n' "$(name_of $(( -n )))"
    return 0
  fi

  # Names for numbers that fit in a bash integer
  local -A names=([0]=zero [1]=one [2]=two [3]=three [4]=four [5]=five
                  [6]=six [7]=seven [8]=eight [9]=nine [10]=ten [11]=eleven
                  [12]=twelve [13]=thirteen [14]=fourteen [15]=fifteen
                  [16]=sixteen [17]=seventeen [18]=eighteen [19]=nineteen
                  [20]=twenty [30]=thirty [40]=forty [50]=fifty [60]=sixty
                  [70]=seventy [80]=eighty [90]=ninety [100]=hundred
                  [1000]=thousand [1000000]=million [1000000000]=billion
                  [1000000000000]=trillion [1000000000000000]=quadrillion
                  [1000000000000000000]=quintillion)

  # The powers of 10 above 10, in descending order
  local powers_of_10=($(printf '%s\n' "${!names[@]}" | sort -nr | grep '00$'))

  # find the largest power of 10 that is smaller than n
  local -i i=0
  local -i p=${powers_of_10[i]}
  while ((  p > n  && i < ${#powers_of_10[@]}-1 )); do
    i=i+1
    p=${powers_of_10[$i]}
  done

  # if we found one, split on it and construct quotient 'name' remainder
  if (( n >= p )); then
    local -i quotient=n/p
    local -i remainder=n%p
    local remname=
    if (( remainder > 0 )); then
        remname=$(name_of $remainder)
    fi
    printf '%s %s\n' "$(name_of $quotient)" "${names[$p]}${remname:+ $remname}"
  elif (( n > 20 )); then
    # things are a little different under 100, since the multiples of
    # 10 have their own names
    local -i remainder=n%10
    local -i tens=n-remainder
    local remname=
    if (( remainder > 0 )); then
      remname=-$(name_of $remainder)
    fi
    printf '%s\n' "${names[$tens]}${remname:+$remname}"
  else
    printf '%s\n' "${names[$n]}"
  fi

  return 0
}

# Convert numbers into the length of their names
# Display the series of values in name form until
# the length turns into four; then terminate with "four is magic."
# Again, takes a second argument, this time a prefix, to
# facilitate tail recursion.
four_is_magic() {
  local -i n=$1
  local prefix=$2
  local name=$(name_of $n)

  # capitalize the first entry
  if [[ -z $prefix ]]; then
    name=${name^}
  fi

  # Stop at 4, otherwise count the length of the name and recurse
  if (( $n == 4 )); then
     printf '%s%s is magic.\n' "${prefix:+$prefix, }" "$name"
  else
     local -i len=${#name}
     four_is_magic "$len" "${prefix:+$prefix, }$name is $(name_of $len)"
  fi
}
