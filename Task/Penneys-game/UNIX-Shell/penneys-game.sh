#!/bin/bash
main() {
  printf $'Penney\'s Game\n\n'
  printf 'Flipping to see who goes first ... '

  if [[ $(flip) == H ]]; then
    printf 'I do.\n'
    p2=$(choose_sequence)
    printf 'I choose: %s\n' "$p2"
  else
    printf 'You do.\n'
  fi

  while true; do
    read -p 'Enter your three-flip sequence: ' p1
    p1=$(tr a-z A-Z <<<"$p1")
    case "$p1" in
     "$p2") printf 'Sequence must be different from mine\n';;
     [HT][HT][HT]) break;;
     *) printf $'Sequence must be three H\'s or T\'s\n';;
    esac
  done

  if [ -z "$p2" ]; then
    p2=$(choose_sequence "$p1")
    printf 'I choose: %s\n' "$p2"
  fi

  printf '\nHere we go.  %s, you win; %s, I win.\n' "$p1" "$p2"
  printf 'Flips:'

  flips=
  while true; do
    flip=$(flip)
    printf ' %s' "$flip"
    flips+=$flip
    case "$flips" in
      *$p1) printf $'\nYou win!\n'; exit 0;;
      *$p2) printf $'\nI win!\n'; exit 1;;
    esac
  done
}

choose_sequence() {
  local result
  if (( $# )); then
    case "$1" in
      ?[Hh]?) result=T;;
      *) result=H;;
    esac
    result+="${1%?}"
  else
    result=$(flip)$(flip)$(flip)
  fi
  printf '%s\n' "$result"
}

flip() {
  if (( RANDOM % 2 )); then
    printf '%s\n' H
  else
    printf '%s\n' T
  fi
}

main "$@"
