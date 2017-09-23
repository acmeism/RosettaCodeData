# state: [t,y]
[0,1]
| while( .[0] <= 10;
         .[0] as $t | .[1] as $y
         | [$t + dt, $y + dy(yprime) ] )
| .[0] as $t | .[1] as $y
| if $t | integerq then
     "y(\($t|round(1))) = \($y|round(10000)) ± \( ($t|actual) - $y | abs)"
  else empty
  end
