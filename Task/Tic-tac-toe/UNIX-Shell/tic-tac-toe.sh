#!/usr/bin/env bash
# play tic-tac-toe
main() {
  local play_again=1
  while (( play_again )); do
    local board=(1 2 3 4 5 6 7 8 9) tokens=(X O)
    show_board "${board[@]}"
    # player colors: computer is red, human is green
    local computer=31 human=32
    if (( RANDOM % 2 )); then
      players=(computer human)
      colors=($computer $human)
      printf 'I go first!\n'
    else
      players=(human computer)
      colors=($human $computer)
      printf 'You go first!\n'
    fi
    local token winner
    local -i turn=0
    while ! winner=$(winner "${board[@]}"); do
      token=${tokens[turn%2]}
      case "${players[turn%2]}" in
        human) board=($(human_turn "$token" "${board[@]}"));;
        computer) board=($(computer_turn "$token" "${board[@]}"));;
        *) printf 'Unknown player "%s"\n' "${players[turn%2]}"; exit 1;;
      esac
      show_board "${board[@]}" | sed -e "s/${tokens[0]}/"$'\e['"${colors[0]}"$'m&\e[0m/g' \
                                     -e "s/${tokens[1]}/"$'\e['"${colors[1]}"$'m&\e[0m/g'

      (( turn=turn+1 ))
   done
   case "$winner${players[0]}" in
     Ohuman|Xcomputer) printf 'I win!\n';;
     Xhuman|Ocomputer) printf 'You win!\n';;
     cat*) printf 'The cat wins!\n';;
   esac
   yorn 'Play again'
   play_again=$(( ! $? ))
 done
}

show_board() {
  printf '\n'
  printf '%s %s %s\n' "$@"
  printf '\n'
}

winner() {
  local board=("$@") i j k
  local lines=("0 1 2" "0 3 6" "0 4 8" "1 4 7"
               "2 4 6" "2 5 8" "3 4 5" "6 7 8")
  local line i j k
  for line in "${lines[@]}"; do
    read i j k <<<"$line"
    local token=${board[i]}
    if [[ "${board[j]}" == $token && "${board[k]}" == $token ]]; then
      printf '%s\n' "$token"
      return 0
    fi
  done
  case "${board[*]}" in
    *[1-9]*) return 1;;
    *) printf 'cat\n'; return 0;;
  esac
}

human_turn() {
  local token=$1
  shift
  local board=("$@")
  local n=0
  while (( n < 1 || n > 9 )) || [[ "${board[n-1]}" != $n ]]; do
    printf 'Enter space number: ' "$n"  "${board[n-1]}" >/dev/tty
    read n </dev/tty >/dev/tty 2>&1
  done
  board[n-1]=$token
  printf '%s\n' "${board[@]}"
}

computer_turn() {
  local token=$1
  shift
  local board=("$@")
  local i=0 blanks=() choice
  for (( i=0; i<9; ++i )); do
    if [[ "${board[i]}" == [1-9] ]]; then
      blanks+=("$i")
    fi
  done
  choice=${blanks[RANDOM % ${#blanks[@]}]}
  board[choice]=$token
  printf '%s\n' "${board[@]}"
}

yorn() {
  local yorn=
  while [[ $yorn != [Yy]* && $yorn != [Nn]* ]]; do
    printf '%s? ' "$*"
    read yorn
  done
  [[ $yorn == [Yy]* ]]
}

main "$@"
