##
foreach var x in |-5, 5|  do
  foreach var p in |2, 3| do
    writeln('x is ', x:2, ', p is ', p:1, ', ',
            '-x**p is ', -x ** p:4,  ', -(x)**p is ',  -(x) ** p:4, ', ',
            '(-x)**p is ', (-x) ** p:4, ', ', '-(x**p) is ', -(x ** p):4);
