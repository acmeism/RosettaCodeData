#!/usr/bin/env bash

mem=(15  17  -1  17  -1 -1 16   1  -1  16   3  -1 15 15  0 0 -1
     72 101 108 108 111 44 32 119 111 114 108 100 33 10  0)

addr=0
step=0

while (( addr >= 0 )); do
  (( step++ ))
  a=${mem[addr]}
  b=${mem[addr + 1]}
  c=${mem[addr + 2]}
  (( addr += 3 ))
  if (( b < 0 )); then
     printf '%b' '\x'$(printf '%x' ${mem[a]})
  else
    if (( (mem[b] -= mem[a]) <= 0 )); then
      addr=$c
    fi
  fi
done
printf 'Total step:%d\n' "$step"
