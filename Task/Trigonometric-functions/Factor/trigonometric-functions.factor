USING: kernel math math.constants math.functions math.trig
prettyprint ;

pi 4 / 45 deg>rad [ sin ] [ cos ] [ tan ]
[ [ . ] compose dup compose ] tri@ 2tri

.5 [ asin ] [ acos ] [ atan ] tri [ dup rad>deg [ . ] bi@ ] tri@
