a = .array~of(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0)
say "Arithmetic =" arithmeticMean(a)", Geometric =" geometricMean(a)", Harmonic =" harmonicMean(a)

::routine arithmeticMean
  use arg numbers
  -- somewhat arbitrary return for ooRexx
  if numbers~isEmpty then return "NaN"

  mean = 0
  loop number over numbers
      mean += number
  end
  return mean / numbers~items

::routine geometricMean
  use arg numbers
  -- somewhat arbitrary return for ooRexx
  if numbers~isEmpty then return "NaN"

  mean = 1
  loop number over numbers
      mean *= number
  end

  return rxcalcPower(mean, 1 / numbers~items)

::routine harmonicMean
  use arg numbers
  -- somewhat arbitrary return for ooRexx
  if numbers~isEmpty then return "NaN"

  mean = 0
  loop number over numbers
      if number = 0 then return "Nan"
      mean += 1 / number
  end

  -- problem here....
  return numbers~items / mean

::requires rxmath LIBRARY
