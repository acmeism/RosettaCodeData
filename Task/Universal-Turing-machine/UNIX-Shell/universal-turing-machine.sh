#!/usr/bin/env bash
main() {
  printf 'Simple Incrementer\n'
  printf '1 1 1' | run_utm q0 qf B q0,1,1,R,q0 q0,B,1,S,qf

  printf '\nThree-state busy beaver\n'
  run_utm a halt 0 \
    a,0,1,R,b a,1,1,L,c b,0,1,L,a b,1,1,R,b c,0,1,L,b c,1,1,S,halt \
    </dev/null
}

run_utm() {
  local initial=$1 final=$2 blank=$3
  shift 3
  local rules=("$@") tape
  mapfile -t -d' ' tape
  if (( ! ${#tape[@]} )); then
    tape=( "$blank" )
  fi
  local state=$initial
  local head=0
  while [[ $state != $final ]]; do
    print_state "$state" "$head" "${tape[@]}"
    local symbol=${tape[head]}
    local found=0 rule from input output move to
    for rule in "${rules[@]}"; do
      IFS=, read from input output move to <<<"$rule"
      if [[ $state == $from && $symbol == $input ]]; then
        found=1
        break
      fi
    done
    if (( ! found )); then
        printf >&2 "Configuration error: no match for state=$state input=$sym\n"
        return 1
    fi
    tape[head]=$output
    state=$to
    case "$move" in
     L) if (( ! head-- )); then
          head=0
          tape=("$blank" "${tape[@]}")
        fi
        ;;
     R) if (( ++head >= ${#tape[@]} )); then
          tape+=("$blank")
        fi
        ;;
    esac
  done
  print_state "$state" "$head" "${tape[@]}"
}

print_state() {
  local state=$1 head=$2
  shift 2
  local tape=("$@")
  printf '%s' "$state"
  printf '  %s' "${tape[@]}"
  printf '\r'
  (( t = ${#state} + 1 + 3 * head ))
  printf '\e['"$t"'C<\e[C>\n'
}

main "$@"
