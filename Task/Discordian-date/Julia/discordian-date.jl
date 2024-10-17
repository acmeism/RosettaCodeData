using Dates

function discordiandate(year::Integer, month::Integer, day::Integer)
    discordianseasons = ["Chaos", "Discord", "Confusion", "Bureaucracy", "The Aftermath"]
    holidays = Dict(
        "Chaos 5" => "Mungday",
        "Chaos 50" => "Chaoflux",
        "Discord 5" => "Mojoday",
        "Discord 50" => "Discoflux",
        "Confusion 5" => "Syaday",
        "Confusion 50" => "Confuflux",
        "Bureaucracy 5" => "Zaraday",
        "Bureaucracy 50" => "Bureflux",
        "The Aftermath 5" => "Maladay",
        "The Aftermath 50" => "Afflux")
    today = Date(year, month, day)
    isleap = isleapyear(year)
    if isleap && month == 2 && day == 29
        rst = "St. Tib's Day, YOLD " * string(year + 1166)
    else
        dy = dayofyear(today)
        if isleap && dy >= 60
            dy -= 1
        end
        rst = string(discordianseasons[div(dy, 73) + 1], " ", rem(dy, 73)) # day
        if haskey(holidays, rst)
            rst *= " ($(holidays[rst]))" # if holiday
        end
        rst *= ", YOLD $(year + 1166)" # year
    end
    return rst
end

@show discordiandate(2017, 08, 15)
@show discordiandate(1996, 02, 29)
@show discordiandate(1996, 02, 19)
