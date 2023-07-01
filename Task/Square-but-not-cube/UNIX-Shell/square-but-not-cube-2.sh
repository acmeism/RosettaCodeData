#!/usr/bin/env bash

main() {
  local non_cubes=()
  local cubes=()
  local cr=1 cube=1 i square
  for (( i=1; $#non_cubes < 30; ++i )); do
    (( square = i * i ))
    while (( square > cube )); do
      (( cr+=1, cube=cr*cr*cr ))
    done
    if (( square == cube )); then
      cubes+=($square)
    else
      non_cubes+=($square)
    fi
  done
  printf 'Squares but not cubes:\n'
  printf $non_cubes[1]
  printf ', %d' "${(@)non_cubes[2,-1]}"

  printf '\n\nBoth squares and cubes:\n'
  printf $cubes[1]
  printf ', %d' "${(@)cubes[2,-1]}"
  printf '\n'
}

main "$@"
