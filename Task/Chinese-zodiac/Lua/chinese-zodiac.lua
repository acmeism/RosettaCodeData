local ANIMALS = {"Rat","Ox","Tiger","Rabbit","Dragon","Snake","Horse","Goat","Monkey","Rooster","Dog","Pig"}
local ELEMENTS = {"Wood","Fire","Earth","Metal","Water"}

function element(year)
    local idx = math.floor(((year - 4) % 10) / 2)
    return ELEMENTS[idx + 1]
end

function animal(year)
    local idx = (year - 4) % 12
    return ANIMALS[idx + 1]
end

function yy(year)
    if year % 2 == 0 then
        return "yang"
    else
        return "yin"
    end
end

function zodiac(year)
    local e = element(year)
    local a = animal(year)
    local y = yy(year)
    print(year.." is the year of the "..e.." "..a.." ("..y..")")
end

zodiac(1935)
zodiac(1938)
zodiac(1968)
zodiac(1972)
zodiac(1976)
zodiac(2017)
