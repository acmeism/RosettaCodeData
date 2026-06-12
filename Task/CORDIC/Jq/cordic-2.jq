# The following are pre-computed to avoid using atan and sqrt functions.
def angles: [
    0.78539816339745, 0.46364760900081, 0.24497866312686, 0.12435499454676,
    0.06241880999596, 0.03123983343027, 0.01562372862048, 0.00781234106010,
    0.00390623013197, 0.00195312251648, 0.00097656218956, 0.00048828121119,
    0.00024414062015, 0.00012207031189, 0.00006103515617, 0.00003051757812,
    0.00001525878906, 0.00000762939453, 0.00000381469727, 0.00000190734863,
    0.00000095367432, 0.00000047683716, 0.00000023841858, 0.00000011920929,
    0.00000005960464, 0.00000002980232, 0.00000001490116, 0.00000000745058
];

def kvalues: [
    0.70710678118655, 0.63245553203368, 0.61357199107790, 0.60883391251775,
    0.60764825625617, 0.60735177014130, 0.60727764409353, 0.60725911229889,
    0.60725447933256, 0.60725332108988, 0.60725303152913, 0.60725295913894,
    0.60725294104140, 0.60725293651701, 0.60725293538591, 0.60725293510314,
    0.60725293503245, 0.60725293501477, 0.60725293501035, 0.60725293500925,
    0.60725293500897, 0.60725293500890, 0.60725293500889, 0.60725293500888
];

def PI: (1 | atan * 4);

def radians: . * PI / 180;

def Cordic($alpha; $n):
  PI as $PI
  | (if (($alpha / (2 * $PI))|floor % 2 == 1) then 1 else -1 end) as $newsgn
  | if ($alpha < -$PI/2)
    then Cordic($alpha + $PI; $n) | map(. * $newsgn)
    elif ($alpha >  $PI/2)
    then Cordic($alpha - $PI; $n) | map(. * $newsgn)
    else kvalues[ [$n-1, (kvalues|length-1)] | min] as $kn
    | reduce angles[0:$n][] as $atan ({ theta: 0, x: 1, y: 0, pow2: 1};
        (if .theta < $alpha then 1 else -1 end) as $sigma
        | .theta += $sigma * $atan
        | .x as $t
        | .x = (.x - $sigma * .y * .pow2)
        | .y = (.y + $sigma * $t * .pow2)
        | .pow2 /= 2 )
    | [.x * $kn, .y * $kn]
    end;

def example:
  def format: map(round(8) | lpad(11)) | join(" ");
  "    x         sin(x)     diff. sine   cos(x)   diff. cosine",
  ({ th: -90 }
   | whilst (.th <= 90;
       (.th | radians) as $thr
       | Cordic($thr; 24) as [ $cos, $sin ]
       | .out = [.th, $sin, $sin - ($thr|sin), $cos, $cos - ($thr|cos) ]
       | .th += 15 )
   | .out
   | format),

  "\n    x(rads)   sin(x)     diff. sine   cos(x)   diff. cosine",
  ((-9, 0, 1.5, 6) as $thr
   | Cordic($thr; 24) as [$cos, $sin]
   | [$thr, $sin, $sin - ($thr|sin), $cos, $cos - ($thr|cos)]
   | format) ;

example
