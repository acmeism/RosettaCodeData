local Time = require("time")

function div (x, y) return math.floor(x / y) end

function easter (year)
    local G = year % 19
    local C = div(year, 100)
    local H = (C - div(C, 4) - div((8 * C + 13), 25) + 19 * G + 15) % 30
    local I = H - div(H, 28) * (1 - div(29, H + 1)) * (div(21 - G, 11))
    local J = (year + div(year, 4) + I + 2 - C + div(C, 4)) % 7
    local L = I - J
    local month = 3 + div(L + 40, 44)
    return month, L + 28 - 31 * div(month, 4)
end

function holidays (year)
    local dates = {}
    dates.easter = Time.date(year, easter(year))
    dates.ascension = dates.easter + Time.days(39)
    dates.pentecost = dates.easter + Time.days(49)
    dates.trinity   = dates.easter + Time.days(56)
    dates.corpus    = dates.easter + Time.days(60)
    return dates
end

function puts (...)
    for k, v in pairs{...} do io.write(tostring(v):sub(6, 10), "\t") end
end

function show (year, d)
    io.write(year, "\t")
    puts(d.easter, d.ascension, d.pentecost, d.trinity, d.corpus)
    print()
end

print("Year\tEaster\tAscen.\tPent.\tTrinity\tCorpus")
for year = 1600, 2100, 100 do show(year, holidays(year)) end
for year = 2010, 2020 do show(year, holidays(year)) end
