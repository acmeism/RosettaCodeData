#!/usr/bin/env bash
main() {
  local puzzle=({1..15} " ") blank moves_kv i key count total last
  printf '\n'
  show_puzzle "${puzzle[@]}"
  printf '\nPress return to scramble.'
  read _
  IFS= readarray -t puzzle < <(scramble "${puzzle[@]}")
  printf '\r\e[A\e[A\e[A\e[A\e[A\e[A'
  show_puzzle "${puzzle[@]}"
  printf '\nUse hjkl to slide tiles. '
  printf '\r\e[A\e[A\e[A\e[A\e[A'
  total=0
  while ! solved "${puzzle[@]}"; do
    show_puzzle "${puzzle[@]}"
    { read blank; readarray -t moves_kv; } < <(find_moves "${puzzle[@]}")
    local count=${#moves_kv[@]}/2
    local -A moves
    for (( i=0; i<count; i++ )); do
      moves[${moves_kv[i]}]=${moves_kv[i+count]}
    done
    read -r -n 1 key
    printf '\r '
    if [[ "$key" = u ]]; then
      (( total -= 2 ))
      case "$last" in
        h) key=l;;
        j) key=k;;
        k) key=j;;
        l) key=h;;
      esac
    fi
    if [[ -n "${moves[$key]}" ]]; then
      last=$key
      (( total++ ))
      i=${moves[$key]}
      puzzle[$blank]=${puzzle[i]}
      puzzle[i]=' '
    fi
    printf '\r\e[A\e[A\e[A\e[A'
  done
  show_puzzle "${puzzle[@]}"
  printf '\nSolved in %d moves.     \n' "$total"
}


solved() {
  local solved=({1..15} ' ')
  [[ "${puzzle[*]}" == "${solved[*]}" ]]
}

show_puzzle() {
  printf '%2s %2s %2s %2s\n' "$@"
}

find_moves() {
  local puzzle=("$@")
  local i j blank
  for (( i=0; i<${#puzzle[@]}; ++i )); do
    if [[ "${puzzle[i]}" == " " ]]; then
      blank=$i
      break
    fi
  done
  local -A moves=()
  if (( blank%4 )); then
    # swapping blank with tile to its left
    # is sliding that tile right, which is the l key
    moves['l']=$(( blank-1 ))
  fi
  if (( blank%4 != 3 )); then
    moves['h']=$(( blank+1 )) # left
  fi
  if (( blank >= 4 )); then
    moves['j']=$(( blank-4 )) # down
  fi
  if (( blank < 12 )); then
    moves['k']=$(( blank+4 )) # up
  fi
  printf '%s\n' "$blank" "${!moves[@]}" "${moves[@]}"
}

scramble() {
  local puzzle=("$@") i j
  for (( i=0; i<256; ++i )); do
    local blank moves
    { read blank; readarray -t moves; } < <(find_moves "${puzzle[@]}")
    moves=(${moves[@]:${#moves[@]}/2})
    local dir=$(( RANDOM % ${#moves[@]} ))
    j=${moves[dir]}
    puzzle[blank]=${puzzle[j]}
    puzzle[j]=' '
  done
  printf '%s\n' "${puzzle[@]}"
}

main "$@"
