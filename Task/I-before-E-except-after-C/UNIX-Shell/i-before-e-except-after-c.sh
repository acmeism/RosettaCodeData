#!/bin/sh

matched() {
  grep -Poe "$1" unixdict.txt | wc -l
}

check() {
  local num_for="$(matched "$3")"
  local num_against="$(matched "$2")"
  if [ "$num_for" -le "$(expr 2 \* "$num_against")" ]; then
    echo "Clause $1 not plausible ($num_for examples; $num_against counterexamples)"
    return 1
  else
    echo "Clause $1 is plausible ($num_for examples; $num_against counterexamples)"
    return 0
  fi
}

check 1 '(?<!c)ei' '(?<!c)ie'
PLAUSIBLE_1=$?
check 2 'cie' 'cei'
PLAUSIBLE_2=$?
if [ $PLAUSIBLE_1 -eq 0 -a $PLAUSIBLE_2 -eq 0 ]; then
  echo "Overall, the rule is plausible"
else
  echo "Overall, the rule is not plausible"
fi
