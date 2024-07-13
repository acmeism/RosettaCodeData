# Output: a PRN (integer) in range(0; .)
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def rgen:
  1000 | prn / 1000;

# Modified random number generator.
# `modifier` should be a zero-arity filter
def rng(modifier):
  {}
  | until(.r1 and (.r2 < (.r1|modifier));
      .r1 = rgen
      | .r2 = rgen )
  | .r1;

def modifier:
  if (. < 0.5) then 2 * (0.5 - .)
  else 2 * (. - 0.5)
  end;

def N:100000;
def NUM_BINS: 20;
def HIST_CHAR: "■";
def HIST_CHAR_SIZE: 500;
def binSize:1 / NUM_BINS;

def task:
  # tidy decimals
  def round($ndec): pow(10;$ndec) as $p | . * $p | round / $p;
  def zpad($len): tostring | ($len - length) as $l | . + ("0" * $l);
  def r: if . == 0 then "0.00" else round(2) | zpad(4) end;
  reduce range(0; N) as $i ([];
      rng(modifier) as $rn
     | (($rn / binSize)|floor) as $bn
     | .[$bn] += 1)
  | {bins: .}
  | "Modified random distribution with \(N) samples in range [0, 1):",
     "  Range             Number of samples within that range",
     (foreach range(0; NUM_BINS) as $i (.;
        (HIST_CHAR * (((.bins[$i] // 0) / HIST_CHAR_SIZE) | round)) as $hist
        | .emit = "\(binSize * $i|r) -  \($hist) \(.bins[$i] // 0)"  )
    | .emit);

task
