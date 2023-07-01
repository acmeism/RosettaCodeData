#!/usr/bin/env bash
namegame() {
  local name=$1 b=b f=f m=m
  local rhyme=${name#[^AaEeIiOoUu]}
  while [[ $rhyme == [^AaEeIiOoUuYy]* ]]; do
    rhyme=${rhyme#?}
  done
  if [[ "$rhyme" == [AEIOU]* ]]; then
    rhyme=$(tr A-Z a-z <<<"$rhyme")
  fi
  if [[ $name == [Bb]* ]]; then
    b=
  fi
  if [[ $name == [Ff]* ]]; then
    f=
  fi
  if [[ $name == [Mm]* ]]; then
    m=
  fi
  printf '%s, %s, bo-%s%s\n' "$name" "$name" "$b" "$rhyme"
  printf 'Banana-fana fo-%s%s\n' "$f" "$rhyme"
  printf 'Fee-fi-mo-%s%s\n' "$m" "$rhyme"
  printf '%s!\n' "$name"
}


for name in Gary Earl Billy Felix Mark Frank; do
  namegame "$name"
  echo
done
