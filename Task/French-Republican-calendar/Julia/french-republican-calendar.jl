using Dates

const GC_FORMAT = DateFormat("d U y")

const RC_FIRST_DAY = Date(1792, 9, 22)

const MAX_RC_DATE = Date(1805, 12, 31)

const RC_MONTHS = [
    "Vendémiaire", "Brumaire", "Frimaire", "Nivôse", "Pluviôse", "Ventôse",
    "Germinal", "Floréal", "Prairial", "Messidor", "Thermidor", "Fructidor"
]

const RC_DAYS_IN_MONTH = 30

const RC_SANSCULOTTIDES = [
    "Fête de la vertu", "Fête du génie", "Fête du travail",
    "Fête de l'opinion", "Fête des récompenses", "Fête de la Révolution"
]

additionaldaysforyear(yr) = yr > 11 ? 3 : yr > 7 ? 2 : yr > 3 ? 1 : 0
additionaldaysformonth(mo) = 30 * (mo - 1)
daysforFete(s) = findfirst(x -> x == s, RC_SANSCULOTTIDES) + 359

function togregorian(rc::String)
    yearstring, firstpart = reverse.(split(reverse(strip(rc)), r"\s+", limit=2))
    rcyear = parse(Int, yearstring)
    pastyeardays = (rcyear - 1) * 365 + additionaldaysforyear(rcyear)
    if isnumeric(firstpart[1])
        daystring, monthstring = split(firstpart, r"\s+", limit=2)
        nmonth = findfirst(x -> x == monthstring, RC_MONTHS)
        pastmonthdays = 30 * (nmonth - 1)
        furtherdays = parse(Int, daystring) + pastmonthdays + pastyeardays - 1
    else
        furtherdays = daysforFete(firstpart) + pastyeardays
    end
    gregorian = RC_FIRST_DAY + Day(furtherdays)
    if furtherdays < 0 || gregorian > MAX_RC_DATE
        throw(DomainError("French Republican Calendar date out of range"))
    end
    return Day(gregorian).value, monthname(Month(gregorian).value), Year(gregorian).value
end

function torepublican(gc::String)
    date = Date(DateTime(gc, GC_FORMAT))
    if date < RC_FIRST_DAY || date > MAX_RC_DATE
        throw(DomainError("French Republican Calendar date out of range"))
    end
    rcyear, rcdays = divrem(((date - RC_FIRST_DAY).value + 366), 365)
    rcdays -= additionaldaysforyear(rcyear)
    if rcdays < 1
        rcyear -= 1
        rcdays += 366
    end
    if rcdays < 361
        nmonth, rcday = divrem(rcdays, 30)
        return rcday, RC_MONTHS[nmonth + 1], rcyear
    else
        return RC_SANSCULOTTIDES[rcdays - 360], rcyear
    end
end

const republican = [
    "1 Vendémiaire 1", "1 Prairial 3", "27 Messidor 7",
    "Fête de la Révolution 11", "10 Nivôse 14"
]

const gregorian = [
    "22 September 1792", "20 May 1795", "15 July 1799",
    "23 September 1803", "31 December 1805"
]

function testrepublicancalendar()
    println("French Republican to Gregorian")
    for s in republican
        println(lpad(s, 24), " => ", togregorian(s))
    end
    println("Gregorian to French Republican")
    for s in gregorian
        println(lpad(s, 24), " => ", torepublican(s))
    end
end

testrepublicancalendar()
