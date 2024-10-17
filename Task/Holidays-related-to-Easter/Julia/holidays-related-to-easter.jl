# v0.6

using Dates

function easter(year::Int)::Date
    a = rem(year, 19)
    b, c = divrem(year, 100)
    d = rem(19a + b - div(b, 4) - div(b - div(b + 8, 25) + 1, 3) + 15, 30)
    e = rem(32 + 2 * rem(b, 4) + 2 * div(c, 4) - d - rem(c, 4), 7)
    f = d + e - 7 * div(a + 11d + 22e, 451) + 114
    month, day = divrem(f, 31)
    day += 1
    return Date(year, month, day)
end

function holiday_values(year::Int)::Dict{String,Date}
    offsets = Dict{String,Day}("Easter" => Day(0), "Ascension" => Day(39),
    "Pentecost" => Day(49), "Trinity" => Day(56), "Corpus" => Day(60))
    easterdate = easter(year)
    rst = Dict{String,Date}(holiday => easterdate + days for (holiday, days) in offsets)
    return rst
end

function holiday2str(year::Int)::String
    function holiday2str(holiday::String, date::Date)::String
        dayname, daynumb, month = dayabbr(date), day(date), monthabbr(date)
        return @sprintf "%s: %s %2i %s" holiday dayname daynumb month
    end
    cal = holiday_values(year)
    rst = join(collect(holiday2str(hday, cal[hday]) for hday in
    ("Easter", "Ascension", "Pentecost", "Trinity", "Corpus")), ", ")
    return "$year -> " * rst
end

println("\nChristian holidays, related to Easter, for each centennial from 400 to 2100 CE:")
for yr in 400:100:2200
    println(holiday2str(yr))
end

println("\nChristian holidays, related to Easter, for years from 2010 to 2020 CE:")
for yr in 2010:2020
    println(holiday2str(yr))
end
