# Input: an array
# Output: the array augmented with another x,y pair
def peano($x; $y; $lg; $i1; $i2):
  $lg as $width
  | def p($x; $y; $lg; $i1; $i2):
    if $lg == 1
    then (($width - $x) * 10) as $px
    | (($width - $y) * 10) as $py
    | . + [[$px,$py]]
    else (($lg/3) | floor) as $lg
    | p($x+2*$i1*$lg; $y+2*$i1*$lg; $lg; $i1; $i2)
    | p($x+($i1-$i2+1)*$lg; $y+($i1+$i2)*$lg; $lg; $i1; 1-$i2)
    | p($x+$lg; $y+$lg; $lg; $i1; 1-$i2)
    | p($x+($i1+$i2)*$lg; $y+($i1-$i2+1)*$lg; $lg; 1-$i1; 1-$i2)
    | p($x+2*$i2*$lg; $y+2*(1-$i2)*$lg; $lg; $i1; $i2)
    | p($x+(1+$i2-$i1)*$lg; $y+(2-$i1-$i2)*$lg; $lg; $i1; $i2)
    | p($x+2*(1-$i1)*$lg; $y+2*(1-$i1)*$lg; $lg; $i1; $i2)
    | p($x+(2-$i1-$i2)*$lg; $y+(1+$i2-$i1)*$lg; $lg; 1-$i1; $i2)
    | p($x+2*(1-$i2)*$lg; $y+2*$i2*$lg; $lg; 1-$i1; $i2)
  end;
  p($x; $y; $lg; $i1; $i2);

def svg:
  "<svg viewBox=\"0 0 820 820\" xmlns=\"http://www.w3.org/2000/svg\">" ;

def path($fill; $stroke):
  "<path fill=\"\($fill)\" stroke=\"\($stroke)\" d=\"M ";

def endpath:
  " \" /> </svg>";

def peanoCurve:
  null | peano(0; 0; 81; 0; 0) | map(join(",")) | join(" ");

svg,
( path("none"; "red") + peanoCurve + endpath)
