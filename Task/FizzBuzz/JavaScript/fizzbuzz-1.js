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

// ------------------
// functional version
// ------------------
(function (n) {
     var r = [];

     while (n--) {
         r.push(n + 1);
     }

     return r.reverse();
 })(100).map(function (n) {
     return !(n % 15) ?
         'FizzBuzz' :
         !(n % 3) ?
             'Fizz' :
             !(n % 5) ?
                 'Buzz' :
                 n;
 }).join('\r\n');
