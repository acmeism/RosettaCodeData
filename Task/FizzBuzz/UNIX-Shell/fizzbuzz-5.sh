command_not_found_handle () {
  local Fizz=3 Buzz=5
  [ $(( $2 % $1 )) -eq 0 ] && echo -n $1 && [ ${!1} -eq 3 ]
}

for i in {1..100}
do
  Fizz $i && ! Buzz $i || echo -n $i
  echo
done
