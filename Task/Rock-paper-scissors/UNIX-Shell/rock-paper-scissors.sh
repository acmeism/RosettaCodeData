#!/bin/bash
choices=(rock paper scissors)

# comparison function, works like Perl
# winner x y =  2 if y beats x, 1 if x beats 1, 0 if it's a tie
winner() {
  local left="$1" right="$2"
  echo $(( (3 + left - right) % 3 ))
}


human_counts=(1 1 1)
human_count=3
computer_counts=(0 0 0)
games=0 human=0 computer=0

PS3="What do you throw? "
while true; do
  select choice in rock paper scissors quit; do
    if [ -z "$choice" ]; then choice="$REPLY"; fi
    if [ "$choice" = "quit" ]; then
      break 2
    fi
    for (( h=0; h<${#choices[@]}; ++h )); do
      if [ "${choices[h]}" = "$choice" ]; then
        break
      fi
    done
    if (( h < 3 )); then
      break
    fi
    echo "Unrecognized choice.  Try again!"
  done

  let n=RANDOM%human_count
  for (( c=0; c<${#human_counts[@]}; ++c )); do
    let n-=${human_counts[c]}
    if (( n < 0 )); then
       break
    fi
  done
  let computer_counts[c]+=1
  echo
  echo "You chose ${choices[h]^^}"
  echo "I chose ${choices[c]^^}"
  w="$(winner "$c" "$h")"
  case "$w" in
     2) echo "YOU WIN!"; let human+=1;;
     0) echo "TIE!";;
     1) echo "I WIN!"; let computer+=1;;
     *) echo "winner returned weird result '$w'";;
  esac
  echo
  let games+=1
  (( human_counts[(h+1)%3]+=1, human_count+=1 ))
done

echo
echo "We played $games games.  You won $human, and I won $computer."
for (( i=0; i<3; ++i )); do
  echo "You picked ${choices[i]} $(( human_counts[ (i+1)%3 ] - 1 )) times."
  echo "I picked ${choices[i]} $(( computer_counts[i] )) times."
done
