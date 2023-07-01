: fizzbuzz
| i |
   100 loop: i [
      null
      i 3 mod ifZero: [ "Fizz" + ]
      i 5 mod ifZero: [ "Buzz" + ]
      dup ifNull: [ drop i ] .
      ] ;
