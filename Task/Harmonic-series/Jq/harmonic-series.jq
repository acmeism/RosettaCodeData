# include "rational"; # a reminder

def harmonic:
  reduce range(1; 1+.) as $i ( r(0;1);
    radd(.; r(1; $i) ));

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def task1:
  "The first 20 harmonic numbers and the 100th, expressed in rational form, are:",
  (range(1;21), 100
   | "\(.) : \(harmonic|rpp)" );

def task2($limit):
  "The first harmonic number to exceed the following integers is:",
      limit($limit;
    foreach range(0; infinite) as $n (
      {i: 1, n: 1, h: r(0;1)};
      .emit = false
      | .h = radd(.h; r(1; .n))
      | .i as $i
      | if .h | rgreaterthan($i)
        then .emit = "integer = \(.i|lpad(2))  -> n = \(.n| lpad(6))  ->  harmonic number = \(.h|r_to_decimal(6)) (to 6dp)"
	| .i += 1
        else .
        end
        | .n += 1;
      select(.emit).emit) );

task1, "", task2(10)
