#!/bin/bash
main() {
  echo "Penney's Game"
  echo -n "Flipping to see who goes first ... "

  if [[ $(flip) == H ]]; then
    echo "I do."
    p2=$(choose_sequence)
    echo "I choose: $p2"
  else
    echo "You do."
  fi

  while true; do
    echo "Enter your three-flip sequence:"
    read p1
    case "$p1" in
     "$p2") echo "Sequence must be different from mine";;
     [hHTt][hHtT][hHtT]) break;;
     *) echo "Sequence must be three H's or T's";;
    esac
  done
  p1=$(tr a-z A-Z <<<"$p1")

  if [ -z "$p2" ]; then
    p2=$(choose_sequence "$p1")
    echo "I choose: $p2"
  fi

  echo
  echo "Here we go.  $p1, you win; $p2, I win."
  flips=

  while true; do
    flip=$(flip)
    echo -n $flip
    flips+=$flip
    while (( ${#flips} > 3 )); do
      flips="${flips#?}"
    done
    case "$flips" in
      *$p1) echo $'\nYou win!'; exit 0;;
      *$p2) echo $'\nI win!'; exit 1;;
    esac
  done
}

choose_sequence() {
  local result
  if (( $# )); then
    case "$1" in
      ?Hh?) result=T;;
      *) result=H;;
    esac
    result+="${1%?}"
  else
    result=$(flip)$(flip)$(flip)
  fi
  echo "$result"
}

flip() {
  if (( RANDOM % 2 )); then
    echo H
  else
    echo T
  fi
}

main "$@"
