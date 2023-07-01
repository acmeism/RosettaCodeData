def m:
{ ul: "╔",
  uc: "╦",
  ur: "╗",
  ll: "╚",
  lc: "╩",
  lr: "╝",
  hb: "═",
  vb: "║",

  m0: " Θ  ",
  m5: "────"
};

def mayan: [
    "    ",
    " ∙  ",
    " ∙∙ ",
    "∙∙∙ ",
    "∙∙∙∙"
];

# decimal number to base-20 array, most significant digit first
def dec2vig:
  [recurse(if . >= 20 then ./20|floor else empty end) | . % 20]
  | reverse;

def vig2quin:
  if . >= 20 then "Cannot convert a number >= 20." | error
  else . as $n
  | [mayan[0], mayan[0], mayan[0], mayan[0]]
  | if $n == 0
    then .[3] = m.m0
    else (($n/5)|floor) as $fives
    | ($n % 5) as $rem
    | .[3-$fives] = mayan[$rem]
    | reduce range(3; 3-$fives; -1) as $i (.; .[$i] = m.m5)
    end
  end;

def draw($mayans):
  ($mayans|length) as $lm
  | (reduce range(0; $lm) as $i (m.ul;
       . + m.hb * 4 + if $i < $lm - 1 then m.uc else m.ur + "\n" end ) )
    + (reduce range(1; 5) as $i ("";
         . + m.vb
         + (reduce range(0; $lm) as $j ("";
              . + $mayans[$j][$i-1] + m.vb)) + "\n" ) )
    + (reduce range(0; $lm) as $i (m.ll;
        . + (m.hb * 4)
          + if ($i < $lm - 1) then m.lc else m.lr + "\n" end ) );

def decimal2mayan:
  "Converting \(.) to Mayan:",
  draw(dec2vig | map( vig2quin ) ),
  "" ;

4005, 8017, 326205, 886205, 1081439556
| decimal2mayan
