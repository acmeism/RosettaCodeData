def summary:
  length as $l | add as $sum | ($sum/$l) as $a
  | reduce .[] as $x (0; . + ( ($x - $a) | .*. ))
  | [ $a, (./$l | sqrt)] ;

[ [0,1] | random_normal_variate(1; 0.5; 1000) | .[2] ] | summary
