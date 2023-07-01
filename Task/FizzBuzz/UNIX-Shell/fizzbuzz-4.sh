for ((n=1; n<=100; n++))
do
  fb=''
  [ $(( n % 3 )) -eq 0 ] && fb="${fb}Fizz"
  [ $(( n % 5 )) -eq 0 ] && fb="${fb}Buzz"
  [ -n "${fb}" ] && echo "${fb}" || echo "$n"
done
