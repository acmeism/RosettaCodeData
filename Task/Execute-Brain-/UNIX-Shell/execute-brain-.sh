#!/usr/bin/env bash
# BrainF*** interpreter in bash
if (( ! $# )); then
  printf >&2 'Usage: %s program-file\n' "$0"
  exit 1
fi

# load the program
exec 3<"$1"
program=()
while IFS=  read -r line <&3; do
  mapfile -t instr < <(tr -cd '[]<>.,+-' <<<"$line" | sed $'s/./&\\\n/g')
  program+=("${instr[@]}")
done
exec 3<&-

# parse loops
loops=()
matches=()
for pc in "${!program[@]}"; do
  instr=${program[pc]}
  if [[ $instr == '[' ]]; then
    loops=("$pc" "${loops[@]}")
  elif [[ $instr == ']' ]]; then
    matches[$pc]=${loops[0]}
    matches[${loops[0]}]=$pc
    loops=(${loops[@]:1})
  fi
done

# execute program
memory=(0)
mp=0
pc=0
while (( pc < ${#program[@]} )); do
  instr=${program[pc]}
  (( pc+=1 ))
  mem=${memory[mp]}
  case "$instr" in
    '[') if (( ! mem )); then (( pc=${matches[pc-1]}+1 )); fi;;
    ']') if (( mem )); then (( pc=${matches[pc-1]}+1 )); fi;;
    +) memory[mp]=$(( (mem + 1) % 256 ));;
    -) memory[mp]=$(( (mem - 1) % 256 ));;
    '>') (( mp+=1 )); if (( mp >= ${#memory[@]} )); then memory+=(0); fi;;
    '<') (( mp-=1 )); if (( mp < 0 )); then memory=(0 "${memory[@]}"); mp=0; fi;;
    .) printf %b $(printf '\\%03o' "$mem");;
    ,) read -n1 c; memory[mp]=$(LC_CTYPE=C printf '%d' "'$c");;
  esac
done
