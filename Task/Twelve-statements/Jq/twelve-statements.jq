def indexed(filter):
  . as $in
  | reduce range(0;length) as $i ([]; if ($i | filter) then . + [$in[$i]] else . end);

def count(value): map(select(. == value)) | length;

# The truth or falsity of the 12 statements can be captured in an array of size 12:
def generate(k):
  if k == 1 then [true], [false]
  else generate(1) + generate(k-1)
  end;

# Input: a boolean array
def evaluate:
  [ (length == 12),                                          #1
    ((.[6:] | count(true)) == 3),                            #2
    ((indexed(. % 2 == 1) | count(true)) == 2),              #3
    (if .[4] then .[5] and .[6] else true end),              #4
    ((.[1:4] | count(false)) == 3),                          #5
    ((indexed(. % 2 == 0) | count(true)) == 4),              #6
    (([.[1], .[2]] | count(true)) == 1),                     #7
    (if .[6] then .[4] and .[5] else true end),              #8
    ((.[0:6] | count(true)) == 3),                           #9
    (.[10] and .[11]),                                      #10
    ((.[6:9] | count(true)) == 1),                          #11
    ((.[0:11] | count(true)) == 4)                          #12
  ];

# The following query generates the solution to the problem:
# generate(12) | . as $vector | if evaluate == $vector then $vector else empty end

# Running "task" as defined next would generate
# both the general solution as well as the off-by-one solutions:

def task:

  # count agreements
  def agreed(x;y): reduce range(0;x|length) as $i (0; if x[$i] == y[$i] then .+1 else . end);

  reduce generate(12) as $vector
    ([]; ($vector | evaluate) as $e
         | agreed($vector; $e) as $agreed
         | if $agreed == 12 then [[12,$vector]] + .
           elif $agreed == 11 then . +  [[11, $vector]]
           else .
           end);

# Since the solutions have been given elsewhere, we simply count the
# number of exact and off-by-one solutions:

task | length
