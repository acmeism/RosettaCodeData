### Generic utilities
def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def sum(s): reduce s as $x (0; . + $x);

# For readability:
def count(s): reduce s as $x (0; . + 1);

### Kruskal-Wallis statistic

# The arguments are assumed to be arrays of boolean values.
def kruskal($a; $b; $c):
  def tobits: map(if . then 1 else 0 end);
  # map the boolean values to 1 (true) or 0 (false).
  ($a|tobits) as $aa
  | ($b|tobits) as $bb
  | ($c|tobits) as $cc
  # aggregate and sort them
  | (($aa + $bb + $cc)|sort) as $ss
  # find rank of first occurrence of 1
  | (($ss|index(1)) + 1) as $ix
  # calculate average ranks for 0 and 1
  | ($ix / 2) as $arf
  | ($ss|length) as $n
  | (($ix + $n) / 2) as $art
  # calculate sum of ranks for each list
  | if any($a,$b,$c; length == 0) then null
  else
    sum($a[] | if . then $art else $arf end) as $sra
  | sum($b[] | if . then $art else $arf end) as $srb
  | sum($c[] | if . then $art else $arf end) as $src
  # calculate H
  | (12/($n*($n+1))) * ($sra*$sra/($a|length) + $srb*$srb/($b|length) + $src*$src/($c|length)) - 3 * ($n + 1)
    end;

### Pseuo-random numbers

# Output: a prn in range(0;$n) where $n is `.`
def prn:
  if . == 1 then 0
  else . as $n
  | ([1, (($n-1)|tostring|length)]|max) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def sample:
  if length == 0 # e.g. null or []
  then null
  else .[length|prn]
  end;

def randFloat:
  (1000|prn) / 1000;

### Simulation

def UNTREATED: 0;
def IRREGULAR: 1;
def REGULAR:   2;
def DOSE_FOR_REGULAR: 100;

def Subject:
  {cumDose:  0,
   category: UNTREATED,
   hadCovid: false,
   updateCount: 0 };

def Subject($cumDose; $category; $hadCovid; $updateCount):
  {$cumDose, $category, $hadCovid, $updateCount};

# Set treatment category based on cumulative treatment taken.
def categorize:
  if .cumDose == 0 then UNTREATED
  elif .cumDose >= DOSE_FOR_REGULAR then REGULAR
  else IRREGULAR
  end;

# Daily update on the input Subject to check for infection and randomly dose.
def update($pCovid; $pStartingTreatment; $pRedose; $dRange):
  if (.hadCovid|not)
  then if (randFloat < $pCovid)
       then .hadCovid = true
       else if (.cumDose == 0 and randFloat < $pStartingTreatment) or
               (.cumDose  > 0 and randFloat < $pRedose)
            then .cumDose += ($dRange|sample)
            | .category = categorize
            end
       end
  | .updateCount += 1
  end;

# Update using default parameters.
def update: update(0.001; 0.005; 0.25; [3, 6, 9]);

# Run the study using the population of size $numSubjects for $duration days.
def runStudy($numSubjects; $duration; $interval):
  def r: . * 1000 | round / 1000;
  def div($i; $j): if $j == 0 then 0 else $i / $j | r | lpad(6) end;

  { population: [range(0; $numSubjects) | Subject],
    unt: 0,
    untCovid: 0,
    irr: 0,
    irrCovid: 0,
    reg:  0,
    regCovid: 0
  }
  | "Total subjects: \($numSubjects)",
    (foreach range(0; $duration) as $day (.;
       reduce range(0; $numSubjects) as $i (.; .population[$i] |= update) ;

       if ( ($day + 1) % $interval == 0 ) or $day == (($duration/2)|floor) - 1 or $day == $duration-1
       then
           .unt      = count(.population[] | select(.category == UNTREATED))
         | .untCovid = count(.population[] | select( .category == UNTREATED and .hadCovid ))
         | .irr      = count(.population[] | select(.category == IRREGULAR ))
         | .irrCovid = count(.population[] | select(.category == IRREGULAR and .hadCovid))
         | .reg      = count(.population[] | select (.category == REGULAR ))
         | .regCovid = count(.population[] | select(.category == REGULAR and .hadCovid))
       | (select( ($day + 1) % $interval == 0 )
          | "Day \($day + 1):",
            "Untreated: N = \(.unt), with infection = \(.untCovid)",
            "Regular Use: N = \(.reg), with infection = \(.regCovid)" ),

         (select($day == (($duration/2)|floor) - 1)
          | "\nAt midpoint, Infection case percentages are:",
            "  Untreated : \(div(100 * .untCovid ; .unt))",
            "  Irregulars: \(div(100 * .irrCovid ; .irr))",
            "  Regulars  : \(div(100 * .regCovid ; .reg))" ),

         (select($day == $duration-1)
          | "\nAt study end, infection case percentages are:",
            "  Untreated : \(div(100 * .untCovid ; .unt)) of group size \(.unt)",
            "  Irregulars: \(div(100 * .irrCovid ; .irr)) of group size \(.irr)",
            "  Regulars  : \(div(100 * .regCovid ; .reg)) of group size \(.reg)",
            ( (.population | map(select(.category == UNTREATED)) | map(.hadCovid)) as $untreated
            | (.population | map(select(.category == IRREGULAR)) | map(.hadCovid)) as $irregular
            | (.population | map(select(.category == REGULAR))   | map(.hadCovid)) as $regular
            | "\nFinal statistics: H = \(kruskal($untreated; $irregular; $regular)|r)"      ) )
       else empty
       end ) );

runStudy(10000; 180; 60)
