# In case your jq does not have "until" defined:
def until(cond; next):
  def _until:
    if cond then . else (next|_until) end;
  _until;

# Zeller's Congruence from [[Day_of_the_week#jq]]

# Use Zeller's Congruence to determine the day of the week, given
# year, month and day as integers in the conventional way.
# If iso == "iso" or "ISO", then emit an integer in 1 -- 7 where
# 1 represents Monday, 2 Tuesday, etc;
# otherwise emit 0 for Saturday, 1 for Sunday, etc.
#
def day_of_week(year; month; day; iso):
  if month == 1 or month == 2 then
    [year - 1, month + 12, day]
  else
    [year, month, day]
  end
  | .[2] + (13*(.[1] + 1)/5|floor)
    +  (.[0]%100)       + ((.[0]%100)/4|floor)
    +  (.[0]/400|floor) - 2*(.[0]/100|floor)
  | if iso == "iso" or iso == "ISO" then 1 + ((. + 5) % 7)
    else . % 7
    end ;
