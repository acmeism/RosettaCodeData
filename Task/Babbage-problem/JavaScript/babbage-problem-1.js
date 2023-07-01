// Every line starting with a double slash will be ignored by the processing machine,
// just like these two.
//
// Since the square root of 269,696 is approximately 519, we create a variable named "n"
// and give it this value.
  n = 519

// The while-condition is in parentheses
// * is for multiplication
// % is for modulo operation
// != is for "not equal"
  while ( ((n * n) % 1000000) != 269696 )
    n = n + 1

// n is incremented until the while-condition is met, so n should finally be the
// smallest positive integer whose square ends in the digits 269,696. To see n, we
// need to send it to the monitoring device (named console).
  console.log(n)
