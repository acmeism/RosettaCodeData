using Dates

const Tzolk´in = [
"Imix´", "Ik´", "Ak´bal", "K´an", "Chikchan", "Kimi", "Manik´", "Lamat", "Muluk", "Ok",
"Chuwen", "Eb", "Ben", "Hix", "Men", "K´ib´", "Kaban", "Etz´nab´", "Kawak", "Ajaw"
]
const Haab´ = [
"Pop", "Wo´", "Sip", "Sotz´", "Sek", "Xul", "Yaxk´in", "Mol", "Ch´en", "Yax",
"Sak´", "Keh", "Mak", "K´ank´in", "Muwan", "Pax", "K´ayab", "Kumk´u", "Wayeb´"
]
const creationTzolk´in = Date(2012, 12, 21)
const zeroHaab´ = Date(2019, 4, 2)
daysperMayanmonth(month) = (month == "Wayeb´" ? 5 : 20)

function tzolkin(gregorian::Date)
    deltadays = (gregorian - creationTzolk´in).value
    rem = mod1(deltadays, 13)
    return string(rem <= 9 ? rem + 4 : rem - 9) * " " * Tzolk´in[mod1(deltadays, 20)]
end

function haab(gregorian::Date)
    rem = mod1((gregorian - zeroHaab´).value, 365)
    month = Haab´[(rem + 21) ÷ 20]
    dayofmonth = rem % 20 + 1
    return dayofmonth < daysperMayanmonth(month) ? "$dayofmonth $month" : "Chum $month"
end

function tolongdate(gregorian::Date)
    delta = (gregorian - creationTzolk´in).value + 13 * 360 * 400
    baktun = delta ÷ (360 * 400)
    delta %= (400 * 360)
    katun = delta ÷ (20 * 360)
    delta %= (20 * 360)
    tun = delta ÷ 360
    delta %= 360
    winal, kin = divrem(delta, 20)
    return mapreduce(x -> lpad(x, 3), *, [baktun, katun, tun, winal, kin])
end

nightlord(gregorian::Date) = "G$(mod1((gregorian - creationTzolk´in).value, 9))"

testdates = [
Date(1963, 11, 21), Date(2004, 06, 19), Date(2012, 12, 18), Date(2012, 12, 21),
Date(2019, 01, 19), Date(2019, 03, 27), Date(2020, 02, 29), Date(2020, 03, 01),
Date(2071, 5, 16), Date(2020, 2, 2)
]

println("Gregorian      Long Count       Tzolk´in  Haab´       Nightlord")
println("-----------------------------------------------------------------")
for date in testdates
    println(rpad(date,14), rpad(tolongdate(date), 18), rpad(tzolkin(date), 10),
        rpad(haab(date), 15), nightlord(date))
end
