public String fizzBuzz(int n){
  return (n>0) ? fizzBuzz(n-1) +
    (n % 15 != 0? n % 5 != 0? n % 3 != 0? (n+"") :"Fizz" : "Buzz" : "FizzBuzz")
               : "";
}
