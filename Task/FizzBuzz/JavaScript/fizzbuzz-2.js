for (var i = 1; i <= 100; i++) {
  console.log({
    truefalse: 'Fizz',
    falsetrue: 'Buzz',
    truetrue: 'FizzBuzz'
  }[(i%3==0) + '' + (i%5==0)] || i)
}
