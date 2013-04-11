   mystring=: a. {~ ?~256        NB. ascii chars 0-255 in random order
   #mystring                       NB. length of string
256
   #stripControlCodes mystring     NB. length of string without control codes
223
   #stripControlExtCodes mystring  NB. length of string without control codes or extended chars
95
   #myunicodestring=: u: ?~1000     NB. unicode characters 0-999 in random order
1000
   #stripControlCodes myunicodestring
967
   #stripControlExtCodes myunicodestring
95
   stripControlExtCodes myunicodestring
k}w:]U3xEh9"GZdr/#^B.Sn%\uFOo[(`t2-J6*IA=Vf&N;lQ8,${XLz5?D0~s)'Y7Kq|ip4<WRCaM!b@cgv_T +mH>1ejPy
