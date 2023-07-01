function middle3digits
{
  typeset -i n="${1#-}"
  typeset -i l=${#n}
  if (( l < 3 )); then
    echo >&2 "$1 has less than 3 digits"
    return 1
  elif (( l % 2 == 0 )); then
    echo >&2 "$1 has an even number of digits"
    return 1
  else
    echo ${n:$((l/2-1)):3}
    return 0
  fi
}

# test
testdata=(123 12345 1234567 987654321 10001 -10001 -123 -100 100 -12345 1 2 -1
          -10 2002 -2002 0)
for n in ${testdata[@]}; do
  printf "%10d: " $n
  middle3digits "$n"
done
