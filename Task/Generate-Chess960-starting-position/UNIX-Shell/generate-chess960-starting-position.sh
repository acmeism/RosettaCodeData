declare -a pieces=(♖ ♖ ♖ ♕ ♗ ♗ ♘ ♘)
declare -i i pick index
declare -ai picking_history
declare attempt

until [[ "$attempt" =~ ♗(..)*♗ ]]
do
  attempt=''
  picking_history=()
  for _ in {1..8}
  do
    while ((picking_history[pick=RANDOM%8]++))
    do :
    done
    attempt+="${pieces[pick]}"
  done
done
for i in {0..7}
do
  if [[ "${attempt:i:1}" = ♖ ]] && ((index++))
  then echo "${attempt:0:i}♔${attempt:i+1}"; break;
  fi
done
