def ym = { it.format('yyyy-MM') }
def years = 1900..2100
def fiveWeekendMonths = fiveWeekends(years)
println "Number of five weekend months: ${fiveWeekendMonths.size()}"
fiveWeekendMonths.each { println (ym(it)) }
