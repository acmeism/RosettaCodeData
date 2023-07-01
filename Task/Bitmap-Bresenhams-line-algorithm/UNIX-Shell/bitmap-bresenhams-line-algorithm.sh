#! /bin/bash

function line {
  x0=$1
  y0=$2
  x1=$3
  y1=$4

  if (( x0 > x1 ))
  then
    (( dx = x0 - x1 ))
    (( sx = -1 ))
  else
    (( dx = x1 - x0 ))
    (( sx = 1 ))
  fi

  if (( y0 > y1 ))
  then
    (( dy = y0 - y1 ))
    (( sy = -1 ))
  else
    (( dy = y1 - y0 ))
    (( sy = 1 ))
  fi

  if (( dx > dy ))
  then
    (( err = dx ))
  else
    (( err = -dy ))
  fi
  (( err /= 2 ))
  (( e2 = 0 ))

  while :
  do
    echo -en "\e[${y0};${x0}H#\e[K"
    (( x0 == x1 && y0 == y1 )) && return
    (( e2 = err ))
    if (( e2 > -dx ))
    then
      (( err -= dy ))
      ((  x0 += sx ))
    fi
    if (( e2 < dy ))
    then
      (( err += dx ))
      ((  y0 += sy ))
    fi
  done
}

# Draw a full screen diamond
COLS=$( tput cols )
LINS=$( tput lines )
LINS=$((LINS-1))
clear
line $((COLS/2)) 1 $((COLS/4)) $((LINS/2))
line $((COLS/4)) $((LINS/2)) $((COLS/2)) $LINS
line $((COLS/2)) $LINS $((COLS/4*3)) $((LINS/2))
line $((COLS/4*3)) $((LINS/2)) $((COLS/2)) 1
echo -e "\e[${LINS}H"
