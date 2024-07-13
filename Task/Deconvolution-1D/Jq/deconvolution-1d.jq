def deconv($g; $f):
  { h: [range(0; ($g|length) - ($f|length) + 1) | 0] }
  | reduce range  ( 0;.h|length) as $n (.;
      .h[$n] = $g[$n]
      | (if $n >= ($f|length) then $n - ($f|length) + 1 else 0 end) as $lower
      | .i = $lower
      | until(.i >= $n;
          .h[$n] -= .h[.i] * $f[$n - .i]
          | .i += 1 )
      | .h[$n] /= $f[0] )
  | .h ;

### The tasks

def h: [-8, -9, -3, -1, -6, 7];
def f: [-3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1];
def g: [24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96, 96, 31, 55, 36, 29, -43, -7];

h,
deconv(g; f),
f,
deconv(g; h)
