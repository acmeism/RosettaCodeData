possible=()
for (( i=0; i<18; ++i )); do
  for (( j=0; j<13; ++j )); do
    for (( k=0; k<6; ++k )); do
      (( n = i*6 + j*9 + k*20 ))
      if (( n )); then
        possible[n]=1
      fi
    done
  done
done

for (( n=100; n; n-- )); do
  if [[ -n ${possible[n]} ]; then
    continue
  fi
  break
done

printf 'Maximum non-McNuggets number is %d\n' $n
