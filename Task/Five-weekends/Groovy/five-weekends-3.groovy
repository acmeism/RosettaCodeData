def yearsWith = fiveWeekendMonths.collect { it.format('yyyy') as int } as Set
def yearsWithout = (years as Set) - yearsWith
println "\nNumber of years without a five weekend month: ${yearsWithout.size()}"
yearsWithout.each { println it }
