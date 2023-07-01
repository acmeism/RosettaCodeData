def divide = { Number x, Number y ->
  x / y
}

def partsOf120 = divide.curry(120)

println "120: half: ${partsOf120(2)}, third: ${partsOf120(3)}, quarter: ${partsOf120(4)}"
