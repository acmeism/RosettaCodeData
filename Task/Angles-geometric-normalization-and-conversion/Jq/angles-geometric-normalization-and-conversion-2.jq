# Normalization as per the task requirements
def mod($y):
  (if . < 0 then -$y else 0 end) as $adjust
  | $adjust + . - ($y * ((. / $y)|floor));

def pi: (1|atan) * 4;

def d2d: mod(360);
def g2g: mod(400);
def m2m: mod(6400);
def r2r: mod(2*pi);
def d2g: d2d * 400 / 360;
def d2m: d2d * 6400 / 360;
def d2r: d2d * pi / 180;
def g2d: g2g * 360 / 400;
def g2m: g2g * 6400 / 400;
def g2r: g2g * pi / 200;
def m2d: m2m * 360 / 6400;
def m2g: m2m * 400 / 6400;
def m2r: m2m * pi / 3200;
def r2d: r2r * 180 / pi;
def r2g: r2r * 200 / pi;
def r2m: r2r * 3200 / pi;

def f1(a;b;c;d;e): "\(a|lpad(15)) \(b|lpad(15)) \(c|lpad(15)) \(d|lpad(15)) \(e|lpad(15))";

def f2(a;b;c;d;e):
  def al: fround(7) | align(10)| hide_trailing_zeros;
  "\(a|al) \(b|al) \(c|al) \(d|al) \(e|al)";

def angles: [-2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1000000];

def task1:
  f1( "degrees";  "normalized degs"; "gradians"; "mils"; "radians"),
  (angles[]
   | f2(.; d2d; d2g; d2m; d2r)) ;

def task2:
  f1("gradians"; "normalized grds"; "degrees"; "mils"; "radians"),
  (angles[]
   | f2(.; g2g; g2d; g2m; g2r));

def task3:
  f1("mils"; "normalized mils"; "degrees"; "gradians"; "radians"),
  (angles[]
   | f2(.; m2m; m2d; m2g; m2r));

def task4:
  f1( "radians"; "normalized rads"; "degrees"; "gradians"; "mils"),
  ( angles[]
   | f2(.; r2r; r2d; r2g; r2m) );

task1, "",
task2, "",
task3, "",
task4
