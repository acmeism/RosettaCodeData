# Input should be an integer
def isPrime:
  . as $n
  | if    ($n < 2)      then false
    elif ($n % 2 == 0)  then $n == 2
    elif ($n % 3 == 0)  then $n == 3
    else 5
    | until( . <= 0;
        if .*. > $n then -1
	elif ($n % . == 0) then 0
        else . + 2
        |  if ($n % . == 0) then 0
           else . + 4
           end
        end)
     | . == -1
     end;

# $primedictionary should be a dictionary of primes up to $small
def ispentapowerprime($primedictionary; $small):

  def isp: if . <= $small then $primedictionary[tostring] else isPrime end;

  . as $n
  | (. * .) as $n2
  | (. * $n2) as $n3
  | all($n + 2, $n + $n + 1, $n2 + $n + 1, $n3 + $n + 1, $n3 * $n + $n + 1; isp);

# Output: a stream of the first $count penta-power prime-seeds
# The size of the dictionary has been chosen with gojq in mind.
def ppprimes($count):
  # The size of primeDictionary has been chosen with gojq's limitations in mind
  ($count | .*.*. | primeDictionary) as $pd

  | limit($count; 1, 2, range(3; infinite; 2) | select(ispentapowerprime($pd; $small)) );

ppprimes(30)
