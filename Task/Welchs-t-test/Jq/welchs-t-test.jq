def mean: add / length;

# Sample variance using division by (length-1)
def variance:
  mean as $m
  | (reduce .[] as $x (0; . + (($x - $m) | .*.))) / (length-1) ;

def welch(a; b):
  ((a|mean) - (b|mean)) /
    (((a|variance/length) + (b|variance/length)) | sqrt) ;

def dof(a; b):
  (a|variance) as $sva
  | (b|variance) as $svb
  | (a|length) as $la
  | (b|length) as $lb
  | ($sva/$la + $svb/$lb) as $n
  |  $n * $n / ($sva*$sva/($la*$la*($la-1)) + $svb*$svb/($lb*$lb*($lb-1))) ;

def simpson0(nf; upper; filter):
  (upper/nf) as $dx0
  | {sum: (( (0|filter) + ($dx0 * 0.5|filter) * 4) * $dx0),
      x0: $dx0 }
  | reduce range(1; nf) as $i (.;
      ( ($i + 1) * upper / nf ) as $x1
      | ((.x0 + $x1) * 0.5) as $xmid
      | ($x1 - .x0) as $dx
      | .sum = .sum + ((.x0|filter)*2 + ($xmid|filter)*4) * $dx
      | .x0 = $x1)
  | (.sum + (upper|filter)*$dx0) / 6 ;

def pValue(a; b):
  dof(a; b) as $nu
  | def f:
    . as $r
    | pow($r; ($nu/2) - 1) / ((1 - $r)|sqrt);

  welch(a; b) as $t
  | (($nu/2)|lgamma) as $g1
  | (0.5|lgamma) as $g2
  | (($nu/2 + 0.5)|lgamma) as $g3
  | simpson0(2000; $nu/($t*$t + $nu); f) / (($g1 + $g2 - $g3)|exp) ;

def d1: [27.5, 21.0, 19.0, 23.6, 17.0, 17.9, 16.9, 20.1, 21.9, 22.6, 23.1, 19.6, 19.0, 21.7, 21.4];
def d2: [27.1, 22.0, 20.8, 23.4, 23.4, 23.5, 25.8, 22.0, 24.8, 20.2, 21.9, 22.1, 22.9, 20.5, 24.4];
def d3: [17.2, 20.9, 22.6, 18.1, 21.7, 21.4, 23.5, 24.2, 14.7, 21.8];
def d4: [21.5, 22.8, 21.0, 23.0, 21.6, 23.6, 22.5, 20.7, 23.4, 21.8, 20.7, 21.7, 21.5, 22.5, 23.6,
    21.5, 22.5, 23.5, 21.5, 21.8];
def d5: [19.8, 20.4, 19.6, 17.8, 18.5, 18.9, 18.3, 18.9, 19.5, 22.0];
def d6: [28.2, 26.6, 20.1, 23.3, 25.2, 22.1, 17.7, 27.6, 20.6, 13.7, 23.2, 17.5, 20.6, 18.0, 23.9,
    21.6, 24.3, 20.4, 24.0, 13.2];
def d7: [30.02, 29.99, 30.11, 29.97, 30.01, 29.99];
def d8: [29.89, 29.93, 29.72, 29.98, 30.02, 29.98];
def x : [3.0, 4.0, 1.0, 2.1];
def y : [490.2, 340.0, 433.9];

pValue(d1; d2),
pValue(d3; d4),
pValue(d5; d6),
pValue(d7; d8),
pValue(x; y)
