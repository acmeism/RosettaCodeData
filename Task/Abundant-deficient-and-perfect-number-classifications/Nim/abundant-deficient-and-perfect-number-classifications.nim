proc sumProperDivisors(number: int) : int =
  if number < 2 : return 0
  for i in 1 .. number div 2 :
    if number mod i == 0 : result += i

var
  sum : int
  deficient = 0
  perfect = 0
  abundant = 0

for n in 1 .. 20000 :
  sum = sumProperDivisors(n)
  if sum < n :
    inc(deficient)
  elif sum == n :
    inc(perfect)
  else :
    inc(abundant)

echo "The classification of the numbers between 1 and 20,000 is as follows :\n"
echo "  Deficient = " , deficient
echo "  Perfect   = " , perfect
echo "  Abundant  = " , abundant
