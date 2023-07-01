#!/bin/bash
# Simulates the "monty hall" probability paradox and shows results.
# http://en.wikipedia.org/wiki/Monty_Hall_problem
# (should rewrite this in C for faster calculating of huge number of rounds)
# (Hacked up by Éric Tremblay, 07.dec.2010)

num_rounds=10 #default number of rounds
num_doors=3 # default number of doors
[ "$1" = "" ] || num_rounds=$[$1+0]
[ "$2" = "" ] || num_doors=$[$2+0]

nbase=1 # or 0 if we want to see door numbers zero-based
num_win=0; num_lose=0

echo "Playing $num_rounds times, with $num_doors doors."
[ "$num_doors" -lt 3 ] && {
  echo "Hey, there has to be at least 3 doors!!"
  exit 1
}
echo

function one_round() {
  winning_door=$[$RANDOM % $num_doors ]
  player_picks_door=$[$RANDOM % $num_doors ]

  # Host leaves this door AND the player's first choice closed, opens all others
  # (this WILL loop forever if there is only 1 door)
  host_skips_door=$winning_door
  while [ "$host_skips_door" = "$player_picks_door" ]; do
    #echo -n "(Host looks at door $host_skips_door...) "
    host_skips_door=$[$RANDOM % $num_doors]
  done

  # Output the result of this round
  #echo "Round $[$nbase+current_round]: "
  echo -n "Player chooses #$[$nbase+$player_picks_door]. "
  [ "$num_doors" -ge 10 ] &&
    # listing too many door numbers (10 or more) will just clutter the output
    echo -n "Host opens all except #$[$nbase+$host_skips_door] and #$[$nbase+$player_picks_door]. " \
  || {
    # less than 10 doors, we list them one by one instead of "all except ?? and ??"
    echo -n "Host opens"
    host_opens=0
    while [ "$host_opens" -lt "$num_doors" ]; do
      [ "$host_opens" != "$host_skips_door" ] && [ "$host_opens" != "$player_picks_door" ] && \
      echo -n " #$[$nbase+$host_opens]"
      host_opens=$[$host_opens+1]
    done
    echo -n " "
  }
  echo -n "(prize is behind #$[$nbase+$winning_door]) "
  echo -n "Switch from $[$nbase+$player_picks_door] to $[$nbase+$host_skips_door]: "
  [ "$winning_door" = "$host_skips_door" ] && {
    echo "WIN."
    num_win=$[num_win+1]
  } || {
    echo "LOSE."
    num_lose=$[num_lose+1]
  }
} # end of function one_round

# ok, let's go
current_round=0
while [ "$num_rounds" -gt "$current_round" ]; do
  one_round
  current_round=$[$current_round+1]
done

echo
echo "Wins (switch to remaining door):  $num_win"
echo "Losses (first guess was correct): $num_lose"
exit 0
