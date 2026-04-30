border:10000
// 2_ to filter 0 and 1
sieve::2_!border
// filter out odds with function
odds:{~0=2!x}
limitarray: 2_!_%border
limitarray: 2,limitarray@&odds'limitarray
// add until higher than border with {x<border}{x+dummy}\dummy
multiples:{ dummy::x; {x<border}{x+dummy}\dummy }'limitarray
// filter out with sieve@&~sieve=x
// 1_dummy2 to filter out first number 2,3, etc.
// noout: to surpress output
noout:{dummy2:x; {sieve::sieve@&~sieve=x}'1_dummy2}'multiples
sieve
