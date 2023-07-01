require 'dll'
strdup=: 'msvcrt.dll _strdup >x *' cd <
free=: 'msvcrt.dll free n x' cd <
getstr=: free ] memr@,&0 _1
