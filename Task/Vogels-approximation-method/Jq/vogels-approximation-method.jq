### Generic functions
def array($n): . as $in | [range(0;$n)|$in];

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def maxSafeInteger: pow(2;53);  # 9007199254740992

def minSafeInteger: -maxSafeInteger;

### The Vogel Approximation Method
# Input: the state
def diff($j; $len; $isRow):
  .min1 = maxSafeInteger
  | .min2 = maxSafeInteger
  | .minP = -1
  | reduce range(0; $len) as $i (.;
      (if $isRow then .colDone[$i] else .rowDone[$i] end) as $done
      | if ($done|not)
         then
            (if $isRow then .costs[$j][$i] else .costs[$i][$j] end) as $c
            | if $c < .min1
              then .min2 = .min1
              | .min1 = $c
              | .minP = $i
              elif ($c < .min2) then .min2 = $c
              end
         end )
  | [.min2 - .min1, .min1, .minP] ;

# Input: the state
def maxPenalty($len1; $len2; $isRow):
  .md = minSafeInteger
  | .pc = -1
  | .pm = -1
  | .mc = -1
  | reduce range(0; $len1) as $i (.;
      (if $isRow then .rowDone[$i] else .colDone[$i] end) as $done
      | if ($done|not)
        then diff($i; $len2; $isRow) as $res
        | if ($res[0] > .md)
          then .md = $res[0]  # max diff
          | .pm = $i          # pos of max diff
          | .mc = $res[1]     # min cost
          | .pc = $res[2]     # pos of min cost
          end
        end )
  | if $isRow
    then [.pm, .pc, .mc, .md]
    else [.pc, .pm, .mc, .md]
    end;

# Input: the state
def nextCell:
  maxPenalty(.nRows; .nCols; true) as $res1
  | maxPenalty(.nCols; .nRows; false) as $res2
  | if $res1[3] == $res2[3]
    then (if ($res1[2] < $res2[2]) then $res1 else $res2 end)
    else (if ($res1[3] > $res2[3]) then $res2 else $res1 end)
    end;

# Vogel's approximation method
def vam($supply; $demand; $costs):
  def nRows: $supply|length;
  def nCols: $demand|length;

  {$supply,
   $demand,
   $costs,
   totalCost: 0,
   nRows: nRows,
   nCols: nCols,
   rowDone: (false | array(nRows)),
   colDone: (false | array(nCols)),
   results: (0 | array(nCols) | array(nRows))
  }
  | .supplyLeft = (.supply | add)

  | until(.supplyLeft <= 0;
      nextCell as $cell
      | $cell[0] as $r
      | $cell[1] as $c
      | ([.demand[$c], .supply[$r]] | min) as $q
      | .demand[$c] += - $q
      | if .demand[$c] == 0 then .colDone[$c] = true end
      | .supply[$r] += - $q
      | if .supply[$r] == 0 then .rowDone[$r] = true end
      | .results[$r][$c] = $q
      | .supplyLeft += - $q
      | .totalCost += $q * .costs[$r][$c] );

# The problem at hand:

def supply: [50, 60, 50, 50];

def demand: [30, 20, 70, 30, 60];

def costs: [
  [16, 16, 13, 22, 17],
  [14, 14, 13, 19, 15],
  [19, 19, 20, 23, 50],
  [50, 12, 50, 15, 11]
];

# The Vogel approximation
vam(supply; demand; costs)
| ["W", "X", "Y", "Z"] as $Row
| "    A   B   C   D   E",
  (range(0; .results|length) as $i
  | .results[$i] as $result
  | ($Row[$i] + ($result | map(lpad(4)) | join("")) ) ),

  "\nTotal Cost = \(.totalCost)"
