list=(20 20 2);
(( sum=0, prod=1 ))
for n in "${list[@]}"; do
   (( sum += n, prod *= n ))
done
printf '%d\t%d\n' "$sum" "$prod"
