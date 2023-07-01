def half = divide.rcurry(2)
def third = divide.rcurry(3)
def quarter = divide.rcurry(4)

println "30: half: ${half(30)}; third: ${third(30)}, quarter: ${quarter(30)}"
