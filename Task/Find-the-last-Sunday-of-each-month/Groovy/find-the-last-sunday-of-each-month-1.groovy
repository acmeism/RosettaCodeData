enum Day {
    Sun, Mon, Tue, Wed, Thu, Fri, Sat
    static Day valueOf(Date d) { Day.valueOf(d.format('EEE')) }
}

def date = Date.&parse.curry('yyyy-MM-dd')
def month = { it.format('MM') }
def days = { year -> (date("${year}-01-01")..<date("${year+1}-01-01")) }
def weekDays = { dayOfWeek, year -> days(year).findAll { Day.valueOf(it) == dayOfWeek } }

def lastWeekDays = { dayOfWeek, year ->
    weekDays(dayOfWeek, year).reverse().inject([:]) { months, sunday ->
        def monthStr = month(sunday)
        !months[monthStr]  ?  months + [(monthStr):sunday]  :  months
    }.values().sort()
}
