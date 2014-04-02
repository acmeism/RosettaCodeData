for (var i = 1; i <= 100; i++) {
  if (i % 15 == 0) {
    console.log("FizzBuzz");
  } else if (i % 3 == 0) {
    console.log("Fizz");
  } else if (i % 5 == 0) {
    console.log("Buzz");
  } else {
    console.log(i);
  }
}

Array.apply(null, { length: 100 }).map(function(n, i) {
  ++i;
  return !(i % 15) ?
    "FizzBuzz" :
    !(i % 3) ?
      "Fizz" :
      !(i % 5) ?
        "Buzz" : i;
}).join("\r\n");
