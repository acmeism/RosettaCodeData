# input and output:  [year, month, day] using month=1 for Jan
# add the number of days to the input date
def addDays($days):
  . as [$y,$m,$d]
  | [$y,$m-1,$d + $days,0,0,0,0,0] | mktime | gmtime[0:3] | .[1]+=1;

# input: [year, month, day], an array of integers
# output:  [yyyy, mm, dd] , an array of strings,
def yyyymmdd:
  def l($len): tostring | ($len - length) as $l | ("0" * $l)[:$l] + .;
  [(.[0]|l(4)), (.[1]|l(2)),  (.[2]|l(2))] ;

# input: [year, month, day] using month=1 for Jan
def isPalDate:
  yyyymmdd  | add  | explode  | . == reverse;

def task:
  "The next 15 palindromic dates in yyyy-mm-dd format after 2020-02-02 are:",
  ( [2020, 2, 2]
    | addDays(1)
    | limit(15; recurse(addDays(1)) | select(isPalDate) )
    | yyyymmdd
    | join("-") );

task
