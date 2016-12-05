:-  %say
|=  [^ ~ ~]
  :-  %noun
  %+  turn   (gulf [1 101])
  |=  a=@
    =+  q=[=(0 (mod a 3)) =(0 (mod a 5))]
    ?+  q  <a>
      [& &]  "FizzBuzz"
      [& |]  "Fizz"
      [| &]  "Buzz"
    ==
