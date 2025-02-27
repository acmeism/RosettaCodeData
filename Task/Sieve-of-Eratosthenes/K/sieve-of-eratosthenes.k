n:100
limit: _%n+1 // until square root +1
iter:(2_!limit),limit  // to be iterated over inclusive limit
numbers: (!n),n // array with numbers until n (inclusive)
sieve: {2_((&0=x!)numbers)} // sieve function first two omitted
dummy: { {yy:x; $[ ( (yy!x) ~ 0 ); numbers[x]:0 ;]}'sieve x}'|iter // iter must be reversed
// this sets multiples in the array numbers to zero, if the modulus is zero
// each x in iter is checked with '
dummy: dummy   // to supress output
1_(0<)#numbers // filter out bigger than zero
