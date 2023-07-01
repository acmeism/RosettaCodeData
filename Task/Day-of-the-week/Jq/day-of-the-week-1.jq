# Use Zeller's Congruence to determine the day of the week, given
# year, month and day as integers in the conventional way.
# If iso == "iso" or "ISO", then emit an integer in 1 -- 7 where
# 1 represents Monday, 2 Tuesday, etc;
# otherwise emit 0 for Saturday, 1 for Sunday, etc.
#
def day_of_week(year; month; day; iso):
  if month == 1 or month == 2 then
    [month + 12, year - 1]
  else
    [month, year]
  end
  | day + (13*(.[0] + 1)/5|floor)
    +  (.[1]%100)       + ((.[1]%100)/4|floor)
    +  (.[1]/400|floor) - 2*(.[1]/100|floor)
  | if iso == "iso" or iso == "ISO" then 1 + ((. + 5) % 7)
    else . % 7
    end;
