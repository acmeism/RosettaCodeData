def rescale_price_fraction(value)
  raise ArgumentError, "value=#{value}, must have: 0 <= value < 1.01" if value < 0 || value >= 1.01
  if     value < 0.06  then  0.10
  elsif  value < 0.11  then  0.18
  elsif  value < 0.16  then  0.26
  elsif  value < 0.21  then  0.32
  elsif  value < 0.26  then  0.38
  elsif  value < 0.31  then  0.44
  elsif  value < 0.36  then  0.50
  elsif  value < 0.41  then  0.54
  elsif  value < 0.46  then  0.58
  elsif  value < 0.51  then  0.62
  elsif  value < 0.56  then  0.66
  elsif  value < 0.61  then  0.70
  elsif  value < 0.66  then  0.74
  elsif  value < 0.71  then  0.78
  elsif  value < 0.76  then  0.82
  elsif  value < 0.81  then  0.86
  elsif  value < 0.86  then  0.90
  elsif  value < 0.91  then  0.94
  elsif  value < 0.96  then  0.98
  elsif  value < 1.01  then  1.00
  end
end
