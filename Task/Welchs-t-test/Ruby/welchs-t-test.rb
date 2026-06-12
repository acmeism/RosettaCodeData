def calculate_p_value(array1, array2)
  return 1.0 if array1.size <= 1
  return 1.0 if array2.size <= 1
  mean1 = array1.sum / array1.size
  mean2 = array2.sum / array2.size
  return 1.0 if mean1 == mean2
  variance1 = 0.0
  variance2 = 0.0
  array1.each do |x|
    variance1 += (mean1 - x)**2
  end
  array2.each do |x|
    variance2 += (mean2 - x)**2
  end
  return 1.0 if variance1 == 0.0 && variance2 == 0.0
  variance1 /= (array1.size - 1)
  variance2 /= (array2.size - 1)
  welch_t_statistic = (mean1 - mean2) / Math.sqrt(variance1 / array1.size + variance2 / array2.size)
  degrees_of_freedom = ((variance1 / array1.size + variance2 / array2.size)**2)	/	(
  (variance1 * variance1) / (array1.size * array1.size * (array1.size - 1)) +
  (variance2 * variance2) / (array2.size * array2.size * (array2.size - 1)))
  a = degrees_of_freedom / 2
  value = degrees_of_freedom / (welch_t_statistic**2 + degrees_of_freedom)
  beta = Math.lgamma(a)[0] + 0.57236494292470009 - Math.lgamma(a + 0.5)[0]
  acu = 10**-15
  return value if a <= 0
  return value if value < 0.0 || value > 1.0
  return value if (value == 0) || (value == 1.0)
  psq = a + 0.5
  cx = 1.0 - value
  if a < psq * value
    xx = cx
    cx = value
    pp = 0.5
    qq = a
    indx = 1
  else
    xx = value
    pp = a
    qq = 0.5
    indx = 0
  end
  term = 1.0
  ai = 1.0
  value = 1.0
  ns = (qq + cx * psq).to_i
  # Soper reduction formula
  rx = xx / cx
  temp = qq - ai
  loop do
    term = term * temp * rx / (pp + ai)
    value += term
    temp = term.abs
    if temp <= acu && temp <= acu * value
      value = value * Math.exp(pp * Math.log(xx) + (qq - 1.0) * Math.log(cx) - beta) / pp
      value = 1.0 - value
      value = 1.0 - value if indx == 0
      break
    end
    ai += 1.0
    ns -= 1
    if ns >= 0
      temp = qq - ai
      rx = xx if ns == 0
    else
      temp = psq
      psq += 1.0
    end
  end
  value
end

d1 = [27.5, 21.0, 19.0, 23.6, 17.0, 17.9, 16.9, 20.1, 21.9, 22.6, 23.1, 19.6, 19.0, 21.7, 21.4]
d2 = [27.1, 22.0, 20.8, 23.4, 23.4, 23.5, 25.8, 22.0, 24.8, 20.2, 21.9, 22.1, 22.9, 20.5, 24.4]
d3 = [17.2, 20.9, 22.6, 18.1, 21.7, 21.4, 23.5, 24.2, 14.7, 21.8]
d4 = [21.5, 22.8, 21.0, 23.0, 21.6, 23.6, 22.5, 20.7, 23.4, 21.8, 20.7, 21.7, 21.5, 22.5, 23.6, 21.5, 22.5, 23.5, 21.5, 21.8]
d5 = [19.8, 20.4, 19.6, 17.8, 18.5, 18.9, 18.3, 18.9, 19.5, 22.0]
d6 = [28.2, 26.6, 20.1, 23.3, 25.2, 22.1, 17.7, 27.6, 20.6, 13.7, 23.2, 17.5, 20.6, 18.0, 23.9, 21.6, 24.3, 20.4, 24.0, 13.2]
d7 = [30.02, 29.99, 30.11, 29.97, 30.01, 29.99]
d8 = [29.89, 29.93, 29.72, 29.98, 30.02, 29.98]
x = [3.0, 4.0, 1.0, 2.1]
y = [490.2, 340.0, 433.9]
s1 = [1.0 / 15, 10.0 / 62.0]
s2 = [1.0 / 10, 2 / 50.0]
v1 = [0.010268, 0.000167, 0.000167]
v2 = [0.159258, 0.136278, 0.122389]
z1 = [9 / 23.0, 21 / 45.0, 0 / 38.0]
z2 = [0 / 44.0, 42 / 94.0, 0 / 22.0]

CORRECT_ANSWERS = [0.021378001462867, 0.148841696605327, 0.0359722710297968,
                   0.090773324285671, 0.0107515611497845, 0.00339907162713746, 0.52726574965384, 0.545266866977794].freeze

pvalue = calculate_p_value(d1, d2)
error = (pvalue - CORRECT_ANSWERS[0]).abs
printf("Test sets 1 p-value = %.14g\n", pvalue)

pvalue = calculate_p_value(d3, d4)
error += (pvalue - CORRECT_ANSWERS[1]).abs
printf("Test sets 2 p-value = %.14g\n", pvalue)

pvalue = calculate_p_value(d5, d6)
error += (pvalue - CORRECT_ANSWERS[2]).abs
printf("Test sets 3 p-value = %.14g\n", pvalue)

pvalue = calculate_p_value(d7, d8)
error += (pvalue - CORRECT_ANSWERS[3]).abs
printf("Test sets 4 p-value = %.14g\n", pvalue)

pvalue = calculate_p_value(x, y)
error += (pvalue - CORRECT_ANSWERS[4]).abs
printf("Test sets 5 p-value = %.14g\n", pvalue)

pvalue = calculate_p_value(v1, v2)
error += (pvalue - CORRECT_ANSWERS[5]).abs
printf("Test sets 6 p-value = %.14g\n", pvalue)

pvalue = calculate_p_value(s1, s2)
error += (pvalue - CORRECT_ANSWERS[6]).abs
printf("Test sets 7 p-value = %.14g\n", pvalue)

pvalue = calculate_p_value(z1, z2)
error += (pvalue - CORRECT_ANSWERS[7]).abs
printf("Test sets z p-value = %.14g\n", pvalue)

printf("the cumulative error is %g\n", error)
