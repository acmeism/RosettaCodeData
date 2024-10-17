function mean(sequence s)
  atom sum
  if length(s) = 0 then
    return 0
  else
    sum = 0
    for i = 1 to length(s) do
      sum += s[i]
    end for
    return sum/length(s)
  end if
end function

sequence test
test = {1.0, 2.0, 5.0, -5.0, 9.5, 3.14159}
? mean(test)
