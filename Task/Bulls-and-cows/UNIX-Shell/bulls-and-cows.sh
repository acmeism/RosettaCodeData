#!/bin/bash

rand() {
  local min=${1:-0}
  local max=${2:-32767}

  [ ${min} -gt ${max} ] &&
  min=$(( min ^ max )) &&
  max=$(( min ^ max )) &&
  min=$(( min ^ max ))

  echo -n $(( ( $RANDOM % $max ) + $min ))
}

in_arr() {
  local quandry="${1}"
  shift
  local arr=( $@ )
  local i=''

  for i in ${arr[*]}
  do
    [ "${quandry}" == "${i}" ] && return 0 && break
  done

  return 1
}

delete_at() {
  local idx="$(( $1 + 1 ))"
  shift
  local arr=( "sentinel" $@ )

  echo -n "${arr[@]:1:$(( idx - 1 ))} ${arr[@]:$((idx + 1)):$(( ${#arr[@]} - idx - 1))}"
}

delete_first() {
  local meanie="${1}"
  shift
  local arr=( $@ )
  local i=0

  for (( i = 0; i < ${#arr[@]} ; i++ ))
  do
    [ "${arr[${i}]}" == "${meanie}" ] && arr=( $( delete_at ${i} ${arr[*]} ) )
  done

  echo -n "${arr[*]}"
}

to_arr() {
  local string="${1}"
  local arr=()

  while [ "${#string}" -gt 0 ]
  do
    arr=( ${arr[*]} ${string:0:1} )
    string="${string:1}"
  done

  echo -n "${arr[*]}"
}

choose_idx() {
  local arr=( $@ )

  echo -n "$( rand 0 $(( ${#arr[@]} - 1 )) )"
}

locate_bulls() {
  local secret=( $( to_arr "${1}" ) )
  local guess=( $( to_arr "${2}" ) )
  local hits=()
  local i=0

  for (( i=0; i<4; i++ ))
  do
    [ "${secret[${i}]}" -eq "${guess[${i}]}" ] && hits=( ${hits[*]} ${i} )
  done

  echo -n "${hits[*]}"
}

bulls() {
  local secret="${1}"
  local guess="${2}"
  local bulls=( $( locate_bulls "${secret}" "${guess}" ) )

  echo -n "${#bulls[@]}"
}

cows() {
  local secret=( $( to_arr "${1}" ) )
  local guess=( $( to_arr "${2}" ) )
  local bulls=( $( locate_bulls "${1}" "${2}" ) )
  local hits=0
  local i=''

  # Avoid double-counting bulls
  for i in ${bulls[*]}
  do
    secret=( $( delete_at ${i} ${secret[*]} ) )
  done

  # Process the guess against what's left of the secret
  for i in ${guess[*]}
  do
    in_arr "${i}" ${secret[*]} &&
    secret=( $( delete_first "${i}" ${secret[*]} ) ) &&
    (( hits++ ))
  done

  echo -n ${hits}
}

malformed() {
  local guess=( $( to_arr "${1}" ) )
  local i=''

  [ ${#guess[@]} -ne 4 ] &&
  return 0

  for i in ${guess[*]}
  do
    if ! in_arr ${i} 1 2 3 4 5 6 7 8 9
    then
      return 0
      break
    fi
  done

  return 1
}

candidates=( 1 2 3 4 5 6 7 8 9 )
secret=''

while [ "${#secret}" -lt 4 ]
do
  cidx=$( choose_idx ${candidates[*]} )
  secret="${secret}${candidates[${cidx}]}"
  candidates=( $(delete_at ${cidx} ${candidates[*]} ) )
done

while read -p "Enter a four-digit guess:  " guess
do
  malformed "${guess}" && echo "Malformed guess" && continue
  [ "${guess}" == "${secret}" ] && echo "You win!" && exit
  echo "Score: $( bulls "${secret}" "${guess}" ) Bulls, $( cows "${secret}" "${guess}" ) Cows"
done
