for i in [1..100]
  console.log \
    if i % 15 is 0
      "FizzBuzz"
    else if i % 3 is 0
      "Fizz"
    else if i % 5 is 0
      "Buzz"
    else
      i
