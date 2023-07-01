bash-3.00$ date --version
date (coreutils) 5.2.1
Written by David MacKenzie.

Copyright (C) 2004 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
bash-3.00$ uname -a
Linux brslln01 2.6.9-67.ELsmp #1 SMP Wed Nov 7 13:56:44 EST 2007 x86_64 x86_64 x86_64 GNU/Linux
bash-3.00$ for((i=2009; i <= 2121; i++)); do  date -d "$i-12-25" |egrep Sun; done
Sun Dec 25 00:00:00 GMT 2011
Sun Dec 25 00:00:00 GMT 2016
Sun Dec 25 00:00:00 GMT 2022
Sun Dec 25 00:00:00 GMT 2033
Sun Dec 25 00:00:00 GMT 2039
Sun Dec 25 00:00:00 GMT 2044
Sun Dec 25 00:00:00 GMT 2050
Sun Dec 25 00:00:00 GMT 2061
Sun Dec 25 00:00:00 GMT 2067
Sun Dec 25 00:00:00 GMT 2072
Sun Dec 25 00:00:00 GMT 2078
Sun Dec 25 00:00:00 GMT 2089
Sun Dec 25 00:00:00 GMT 2095
Sun Dec 25 00:00:00 GMT 2101
Sun Dec 25 00:00:00 GMT 2107
Sun Dec 25 00:00:00 GMT 2112
Sun Dec 25 00:00:00 GMT 2118
bash-3.00$
