# Pseudosleep for at least the given number of $seconds (a number)
# and emit the actual number of seconds that have elapsed.
def sleep($seconds):
  now
  | . as $now
  | until( .  - $now >= $seconds; now)
  | . - $now ;
