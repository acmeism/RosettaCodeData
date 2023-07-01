sdacc = .SDAccum~new
x = .array~of(2,4,4,4,5,5,7,9)
sd = 0
do i = 1 to x~size
   sd = sdacc~value(x[i])
   Say '#'i 'value =' x[i] 'stdev =' sd
end

::class SDAccum
::method sum attribute
::method sum2 attribute
::method count attribute
::method init
  self~sum = 0.0
  self~sum2 = 0.0
  self~count = 0
::method value
  expose sum sum2 count
  parse arg x
  sum = sum + x
  sum2 = sum2 + x*x
  count = count + 1
  return self~stddev
::method mean
  expose sum count
  return sum/count
::method variance
  expose sum2  count
  m = self~mean
  return sum2/count - m*m
::method stddev
  return self~sqrt(self~variance)
::method sqrt
  arg n
  if n = 0 then return 0
  ans = n / 2
  prev = n
  do until prev = ans
    prev = ans
    ans = ( prev + ( n / prev ) ) / 2
  end
  return ans
