# In general, dates should be valid Julian dates on or after Jan 1, 0001, but
# for the most part, this is not checked, in part because some
# computations based on ostensibly invalid dates do produce useful
# results, e.g. days(2000; 1; 1) computes the number of days from Jan 1, 0001
# up to and including Jan 1, 2000 whereas days(2000; 1; 0) excludes Jan 1, 2000.

# Output: the number of days from and including Jan 1, 0001,
# up to but excluding Jan 1 in the year $y for $y >= 1
def days_before:
  if . < 1
  then "The input to days_before should be a positive integer, not \(.)"|error
  else (. - 1 | floor) as $y
  | $y*365 + (($y/4)|floor) - (($y/100)|floor) + (($y/400)|floor)
  end;

def isLeapYear:
   .%4 == 0 and (.%100 != 0 or .%400 == 0);

# The day of the year (Jan 1 is 1)
def day_of_year($y; $m; $d):
  def diy: [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
  def diy2: [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366];
  $d + if ($y|isLeapYear) then diy2[$m-1] else diy[$m-1] end;

# Output: the number of days from Jan 1, 0001 to the specified date, inclusive.
def days($y; $m; $d):
  ($y | days_before) + day_of_year($y; $m; $d);

# Output: the signed difference in the "days" values of the two dates.
# If the first specified date is later than the second specified date,
# then the result is the number of days from and including the earlier date,
# up to but excluding the later date.
def days_between(Year; Month; Day; laterYear; laterMonth; laterDay):
  days(laterYear; laterMonth; laterDay) -
   days(Year; Month; Day);

# Dates in yyyy-mm-dd format or as a numeric array [y,m,d]
def days_between(date; later):
  def toa: if type == "string" then split("-") | map(tonumber) else . end;
  (later  | toa) as $later
  | (date | toa) as $date
  | days_between($date[0]; $date[1]; $date[2]; $later[0]; $later[1]; $later[2]);
