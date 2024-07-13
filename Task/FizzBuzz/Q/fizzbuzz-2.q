q)/ Fizzbuzz
q)fb:{(`$string x)^`fizzbuzz`buzz`fizz`(x mod\:15 5 3)?'0}
q)fb 1+til 20
`1`2`fizz`4`buzz`fizz`7`8`fizz`buzz`11`fizz`13`14`fizzbuzz`16`17`fizz`19`buzz
