# is_prime is designed to work with jq 1.4
def is_prime:
  if . == 2 then true
  else 2 < . and . % 2 == 1 and
       . as $in
       | (($in + 1) | sqrt) as $m
       | (((($m - 1) / 2) | floor) + 1) as $max
       | reduce range(1; $max) as $i
           (true; if . then ($in % ((2 * $i) + 1)) > 0 else false end)
  end;

def popcount:
  def bin: recurse( if . == 0 then empty else ./2 | floor end ) % 2;
  [bin] | add;

def is_pernicious: popcount | is_prime;

# Emit a stream of "count" pernicious numbers greater than
# or equal to m:
def pernicious(m; count):
   if count > 0 then
     if m | is_pernicious then m, pernicious(m+1; count -1)
     else pernicious(m+1; count)
     end
   else empty
   end;

def task:
  # display the first 25 pernicious numbers:
  [ pernicious(1;25) ],

  # display all pernicious numbers between
  #     888,888,877 and 888,888,888 (inclusive).
  [ range(888888877; 888888889) | select( is_pernicious ) ]
;

task
