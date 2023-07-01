[
   [ "beef",    3.8, 36 ], [ "pork",    5.4, 43 ], [ "ham",     3.6, 90 ],
   [ "greaves", 2.4, 45 ], [ "flitch",  4.0, 30 ], [ "brawn",  	2.5, 56 ],
   [ "welt",  	3.7, 67 ], [ "salami",  3.0, 95 ], [ "sausage", 5.9, 98 ]
] const: Items

: rob
| item value |
  0.0 ->value
  15.0 #[ dup second swap third / ] Items sortBy forEach: item [
     dup 0.0 == ifTrue: [ return ]
     dup item second >= ifTrue: [
        "Taking" . item first . " :" . item second dup .cr -
        item third value + ->value continue
        ]
     "And part of" . item first . " :" . dup .cr
     item third * item second / value + "Total value :" . .cr break
     ] ;
