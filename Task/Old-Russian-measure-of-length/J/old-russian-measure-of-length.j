#!/usr/bin/ijconsole
UNIT2MULT=: |:_2 (; ".)&;/\;:'arshin 0.7112 centimeter 0.01 diuym 0.0254 fut 0.3048 kilometer 1000.0 liniya 0.00254 meter 1.0 milia 7467.6 piad 0.1778 sazhen 2.1336 tochka 0.000254 vershok 0.04445 versta 1066.8'

conv=: UNIT2MULT 1 : 0
 if. 2 ~: # y do. 'ERROR. Need two arguments - number then units'
 else.
  'VALUE UNIT'=. (;~ _&".)&;~/y
  if. _ = VALUE do. 'ERROR. First argument must be a (float) number'
  else.
   try.
     scale=. ({::~ i.&(<UNIT))~/m
     ((":;:inv y),' to:'),":({.m),.({:m)*L:0 VALUE%scale
   catch.
     'ERROR. Only know the following units: ',;:inv{.m
   end.
  end.
 end.
)

NB. for use from os command line only:
exit echo conv }.ARGV
