#!/bin/sh

mem="15 17 -1 17 -1 -1 16 1 -1 16 3 -1 15 15 0 0 -1 72 101 108 108 111 44 32 119 111 114 108 100 33 10 0 "

i=0
for v in $mem
do
  eval 'mem_'$i=$v
  i=$(( $i + 1 ))
done

get_m () {
  eval echo '$mem_'$1
}
set_m () {
  eval 'mem_'$1=$2
}

ADDR=0
STEP=0

while [ ${STEP} -lt 9999 ]
do
  STEP=$(( $STEP + 1 ))
  A=$(get_m $ADDR)
  B=$(get_m $(($ADDR + 1)) )
  C=$(get_m $(($ADDR + 2)) )
  ADDR=$((ADDR + 3))
  if [ $B -lt 0 ]; then
    get_m $A |  awk '{printf "%c",$1}'
  else
    set_m $B $(( $(get_m $B) - $(get_m $A) ))
    if [ $(get_m $B) -le 0 ]; then
      if [ $C -eq -1 ]; then
        echo "Total step:"$STEP
        exit 0
      fi
      ADDR=$C
    fi
  fi
done
echo "Total step:"$STEP
