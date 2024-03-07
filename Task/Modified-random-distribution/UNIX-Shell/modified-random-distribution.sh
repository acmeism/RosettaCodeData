# NOTE: In bash, RANDOM returns an integer from 0 to 32767 (2**15-1)
random() {
  local m="$1"
  local -i random1 random2
  while true
  do
    random1=RANDOM
    random2=RANDOM
    if ((random2 < $("$m" $random1)))
    then echo $random1; break
    fi
  done
}

modifier() {
  local -i x=$1
  echo $((x < 2**14 ? 2**14 - x : x - 2**14 ))
}

declare -i N=10000 bins=20
declare -a histogram
for ((i=0;i<N;i++))
do ((histogram[bins*$(random modifier)/2**15]++))
done

for ((i=0;i<bins;i++))
do
  for ((j=0;j< ${histogram[i]-0}*bins*50/N;j++))
  do echo -n '#'
  done
  echo
done
