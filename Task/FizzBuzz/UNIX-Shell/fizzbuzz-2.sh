for n in `seq 1 100`; do
  if [ $((n % 15)) = 0 ]; then
    echo FizzBuzz
  elif [ $((n % 3)) = 0 ]; then
    echo Fizz
  elif [ $((n % 5)) = 0 ]; then
    echo Buzz
  else
    echo $n
  fi
done
