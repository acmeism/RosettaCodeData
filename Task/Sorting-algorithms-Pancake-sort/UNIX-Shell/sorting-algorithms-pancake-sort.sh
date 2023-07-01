#!/usr/bin/env bash
main() {
  local stack
  local -i n m i
  if (( $# )); then
    stack=("$@")
  else
    stack=($(printf '%s\n' {0..9} | shuf))
  fi
  print_stack 0 "${stack[@]}"

  # start by looking at whole stack
  (( n = ${#stack[@]} ))

  # keep going until we're all sorted
  while (( n > 0 )); do

    # shrink the stack until its bottom is not the right size
    while  (( n > 0 && ${stack[n-1]} == n-1 )); do
      (( n-=1 ))
    done

    # if we got to the top we're done
    if (( n == 0 )); then
      break
    fi

    # find the index of the largest pancake in the unsorted stack
    m=0
    for (( i=1; i < n-1; ++i )); do
      if (( ${stack[i]} > ${stack[m]} )); then
        (( m = i ))
      fi
    done

    # if it's not on top, flip to get it there
    if (( m > 0 )); then
      stack=( $(flip "$(( m + 1 ))" "${stack[@]}") )
      print_stack "$(( m + 1))" "${stack[@]}"
    fi

    # now flip the top to the bottom
    stack=( $(flip "$n" "${stack[@]}" ) )
    print_stack "$n" "${stack[@]}"

    # and move up
    (( n -= 1 ))
  done
  print_stack 0 "${stack[@]}"
}

# display the stack, optionally with brackets around a prefix
print_stack() {
  local prefix=$1
  shift
  if (( prefix )); then
    printf '[%s' "$1"
    if (( prefix > 1 )); then
      printf ',%s' "${@:2:prefix-1}"
    fi
    printf ']'
  else
    printf ' '
  fi
  if (( prefix < $# )); then
    printf '%s' "${@:prefix+1:1}"
    if (( prefix+1 < $# )); then
      printf ',%s' "${@:prefix+2:$#-prefix-1}"
    fi
  fi
  printf '\n'
}

# reverse the first N elements of an array
flip() {
  local -i size end midpoint i
  local stack temp
  size=$1
  shift
  stack=( "$@" )
  if (( size > 1 )); then
    (( end = size - 1 ))
    (( midpoint = size/2 + size % 2 ))
    for (( i=0; i<midpoint; ++i )); do
      temp=${stack[i]}
      stack[i]=${stack[size-1-i]}
      stack[size-1-i]=$temp
    done
  fi
  printf '%s\n' "${stack[@]}"
}

main "$@"
