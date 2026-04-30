--Day of the week task from Rosetta Code wiki
--User:Lnettnay

--In what years between 2008 and 2121 will the 25th of December be a Sunday

include std/datetime.e

datetime dt

for year = 2008 to 2121 do
        dt = new(year, 12, 25)
        if weeks_day(dt) = 1 then -- Sunday = 1
                ? year
        end if
end for
