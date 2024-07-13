### Generic functions
# (-3.2|fraction) #=> -0.2
def fraction:
  if . >= 0 then  . - trunc
  else - (-. | fraction)
  end;

# For gojq
def div($y):
  (. - (. % y)) / $y;

# Convert the input integer to a stream of 0s and 1s, least significant bit first
def bitwise:
  recurse( if . >= 2 then div(2) else empty end) | . % 2;

# Inverse of bitwise:
def stream_to_integer(stream):
  reduce stream as $c ( {power:1 , ans: 0};
      .ans += ($c * .power) | .power *= 2 )
  | .ans;

# . & 2^($n-1)
def bits($n):
  stream_to_integer(limit($n; bitwise));

### Perlin Noise
def permutation: [
    151, 160, 137,  91,  90,  15, 131,  13, 201,  95,  96,  53, 194, 233,   7, 225,
    140,  36, 103,  30,  69, 142,   8,  99,  37, 240,  21,  10,  23, 190,   6, 148,
    247, 120, 234,  75,   0,  26, 197,  62,  94, 252, 219, 203, 117,  35,  11,  32,
     57, 177,  33,  88, 237, 149,  56,  87, 174,  20, 125, 136, 171, 168,  68, 175,
     74, 165,  71, 134, 139,  48,  27, 166,  77, 146, 158, 231,  83, 111, 229, 122,
     60, 211, 133, 230, 220, 105,  92,  41,  55,  46, 245,  40, 244, 102, 143,  54,
     65,  25,  63, 161,   1, 216,  80,  73, 209,  76, 132, 187, 208,  89,  18, 169,
    200, 196, 135, 130, 116, 188, 159,  86, 164, 100, 109, 198, 173, 186,   3,  64,
     52, 217, 226, 250, 124, 123,   5, 202,  38, 147, 118, 126, 255,  82,  85, 212,
    207, 206,  59, 227,  47,  16,  58,  17, 182, 189,  28,  42, 223, 183, 170, 213,
    119, 248, 152,   2,  44, 154, 163,  70, 221, 153, 101, 155, 167,  43, 172,   9,
    129,  22,  39, 253,  19,  98, 108, 110,  79, 113, 224, 232, 178, 185, 112, 104,
    218, 246,  97, 228, 251,  34, 242, 193, 238, 210, 144,  12, 191, 179, 162, 241,
     81,  51, 145, 235, 249,  14, 239, 107,  49, 192, 214,  31, 181, 199, 106, 157,
    184,  84, 204, 176, 115, 121,  50,  45, 127,   4, 150, 254, 138, 236, 205,  93,
    222, 114,  67,  29,  24,  72, 243, 141, 128, 195,  78,  66, 215,  61, 156, 180
];

def grad($hash; $x; $y; $z):
  def bit2: nth(1; bitwise);
  # Convert low 4 bits of hash code into 12 gradient directions:
  ( $hash|bits(4) ) as $h
  | (if $h < 8 then $x else $y end) as $u
  | (if $h < 4 then $y elif ($h == 12 or $h == 14) then $x else $z end) as $v
  | (if ($h % 2 == 0) then $u else -$u end) +
    (if (($h | bit2) == 0) then $v else -$v end) ;

def noise($x; $y; $z):
  def p:
    permutation as $p
    | $p[:256] + [range(256;512) | $p[.-256]];

  def fade:
     . * . * . * (. * (. * 6 - 15) + 10) ;

  def lerp($t; $a; $b):  $a + $t * ($b - $a);

  # Find unit cube that contains point
  ([$x,$y,$z] | map(floor | bits(8))) as [$xi, $yi, $zi]

  # Find relative x, y, z of point in cube
  | ([$x,$y,$z] | map(fraction)) as [$xx, $yy, $zz]

  # Compute fade curves for each of xx, yy, zz
  | ([$xx,$yy,$zz] | map(fade)) as [$u, $v, $w]

  | p as $p
  # Hash co-ordinates of the 8 cube corners
  # and add blended results from 8 corners of cube
  | ($p[$xi] + $yi) as $a
  | ($p[$a] + $zi) as $aa
  | ($p[$a + 1] + $zi) as $ab
  | ($p[$xi + 1] + $yi) as $b
  | ($p[$b] + $zi) as $ba
  | ($p[$b + 1] + $zi) as $bb
  | lerp($w;
         lerp($v;
              lerp($u;
                   grad($p[$aa]; $xx; $yy; $zz);
                   grad($p[$ba]; $xx - 1; $yy; $zz));
              lerp($u;
                   grad($p[$ab]; $xx; $yy - 1; $zz);
                   grad($p[$bb]; $xx - 1; $yy - 1; $zz)));
         lerp($v;
              lerp($u;
                   grad($p[$aa + 1]; $xx; $yy; $zz - 1);
                   grad($p[$ba + 1]; $xx - 1; $yy; $zz - 1));
              lerp($u;
                   grad($p[$ab + 1]; $xx; $yy - 1; $zz - 1);
                   grad($p[$bb + 1]; $xx - 1; $yy - 1; $zz - 1))) );

noise(3.14; 42; 7)
