import java.time.LocalDate

def fromDate = LocalDate.parse("2019-01-01")
def toDate = LocalDate.parse("2019-10-19")
def diff = fromDate - toDate
println "Number of days between ${fromDate} and ${toDate}: ${diff}"
