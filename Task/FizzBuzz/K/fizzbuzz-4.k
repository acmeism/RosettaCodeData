fizzbuzz:{
  v:1+!x
  i:(&0=)'v!/:3 5 15
  r:@[v;i 0;{"Fizz"}]
  r:@[r;i 1;{"Buzz"}]
  @[r;i 2;{"FizzBuzz"}]}

`0:$fizzbuzz 100
