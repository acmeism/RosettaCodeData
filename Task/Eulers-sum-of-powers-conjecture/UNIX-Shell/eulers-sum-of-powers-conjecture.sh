MAX=250
pow5=()
for (( i=1; i<MAX; ++i )); do
  pow5[i]=$(( i*i*i*i*i ))
done
for (( a=1; a<MAX; ++a )); do
  for (( b=a+1; b<MAX; ++b )); do
    for (( c=b+1; c<MAX; ++c )); do
      for (( d=c+1; d<MAX; ++d )); do
        (( sum=pow5[a]+pow5[b]+pow5[c]+pow5[d] ))
        (( low=d+3 ))
        (( high=MAX ))
        while (( low <= high )); do
          (( guess=(low+high)/2 ))
          if (( pow5[guess]  == sum )); then
            printf 'Found example: %d⁵+%d⁵+%d⁵+%d⁵=%d⁵\n' "$a" "$b" "$c" "$d" "$guess"
            exit 0
          elif (( pow5[guess] < sum )); then
            (( low=guess+1 ))
          else
            (( high=guess-1 ))
          fi
        done
      done
    done
  done
done
printf 'No examples found.\n'
exit 1
