NB. Naive method
NB. joins two lists of the multiples of 3 and 5, then uses the ~. operator to remove duplicates.
echo 'The sum of the multiples of 3 or 5 < 1000 is ', ": +/ ~. (3*i.334), (5*i.200)

NB. slightly less naive: select the numbers which have no remainder when divided by 3 or 5:
echo 'The sum of the multiples of 3 or 5 < 1000 is still ', ": +/I.+./0=3 5|/i.1000



NB. inclusion/exclusion

triangular =: -:@:(*: + 1&*)
sumdiv =: dyad define
    (triangular <. x % y) * y
)

echo 'For 10^20 - 1, the sum is ', ": +/ (".(20#'9'),'x') sumdiv 3 5 _15
