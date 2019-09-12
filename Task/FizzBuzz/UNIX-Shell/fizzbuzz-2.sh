n=1
while [ 100 -ge n ]; do
  if [ $((n % 15)) -eq 0 ]; then
    echo FizzBuzz
  elif [ $((n % 3)) -eq 0 ]; then
    echo Fizz
  elif [ $((n % 5)) -eq 0 ]; then
    echo Buzz
  else
    echo $n
  fi
  n=$((n + 1))
done
