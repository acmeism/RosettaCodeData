### Generic function
# Replace whatever is at .[$i:$i+1] with $x.
# The input and $x should be of the same type - strings or arrays.
def replace($i; $x): .[:$i] + $x + .[$i+1:];

### Cistercian numerals

# The canvas: an array of strings
def canvas:
  (" " * 11) as $row
  | [range(0; 15) | $row | replace(5; "x")];

def horiz($c1; $c2; $r):
  reduce range($c1; $c2+1) as $c (.; .[$r] |= replace($c; "x"));

def verti($r1; $r2; $c):
  reduce range($r1; $r2+1) as $r (.; .[$r] |= replace($c; "x"));

def diagd($c1; $c2; $r):
  reduce range($c1; $c2+1) as $c (.; .[$r+$c-$c1] |= replace($c;"x"));

def diagu($c1; $c2; $r):
  reduce range($c1; $c2+1) as $c (.; .[$r-$c+$c1] |= replace($c; "x"));

# input: the canvas
def draw($n):
  if   $n == 0 then .
  elif $n == 1 then horiz(6; 10; 0)
  elif $n == 2 then horiz(6; 10; 4)
  elif $n == 3 then diagd(6; 10; 0)
  elif $n == 4 then diagu(6; 10; 4)
  elif $n == 5 then draw(1) | draw(4)
  elif $n == 6 then verti(0; 4; 10)
  elif $n == 7 then draw(1) | draw(6)
  elif $n == 8 then draw(2) | draw(6)
  elif $n == 9 then draw(1) | draw(8)
  elif $n == 10 then horiz(0; 4; 0)
  elif $n == 20 then horiz(0; 4; 4)
  elif $n == 30 then diagu(0; 4; 4)
  elif $n == 40 then diagd(0; 4; 0)
  elif $n == 50 then draw(10) | draw(40)
  elif $n == 60 then verti(0; 4; 0)
  elif $n == 70 then draw(10) | draw(60)
  elif $n == 80 then draw(20) | draw(60)
  elif $n == 90 then draw(10) | draw(80)
  elif $n == 100 then horiz(6; 10; 14)
  elif $n == 200 then horiz(6; 10; 10)
  elif $n == 300 then diagu(6; 10; 14)
  elif $n == 400 then diagd(6; 10; 10)
  elif $n == 500 then draw(100) | draw(400)
  elif $n == 600 then verti(10; 14; 10)
  elif $n == 700 then draw(100) | draw(600)
  elif $n == 800 then draw(200) | draw(600)
  elif $n == 900 then draw(100) | draw(800)
  elif $n == 1000 then horiz(0; 4; 14)
  elif $n == 2000 then horiz(0; 4; 10)
  elif $n == 3000 then diagd(0; 4; 10)
  elif $n == 4000 then diagu(0; 4; 14)
  elif $n == 5000 then draw(1000) | draw(4000)
  elif $n == 6000 then verti(10; 14; 0)
  elif $n == 7000 then draw(1000) | draw(6000)
  elif $n == 8000 then draw(2000) | draw(6000)
  elif $n == 9000 then draw(1000) | draw(8000)
  else "unable to draw \(.)" | error
  end;

def cistercian:
  (./1000|floor) as $thousands
  | (. % 1000) as $n
  | ($n/100|floor) as $hundreds
  | ($n % 100) as $n
  | ($n/10|floor) as $tens
  | ($n % 10) as $ones
  | "\(.):",
    ( canvas
     | draw($thousands*1000)
     | draw($hundreds*100)
     | draw($tens*10)
     | draw($ones)
     | .[] ),
    "" ;

0, 1, 20, 300, 4000, 5555, 6789, 9999
| cistercian
