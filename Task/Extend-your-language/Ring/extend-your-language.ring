# Project : Extend your language
# Date    : 2017/11/15
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

see "a = 1, b = 1 => "
test(1, 1)
see "a = 1, b = 0 => "
test(1, 0)
see "a = 0, b = 1 => "
test(0, 1)
see "a = 0, b = 0 => "
test(0, 0)
see nl

func test(a,b)
       if a > 0 and b > 0
          see "both positive"
       but a > 0
           see "first positive"
       but b > 0
           see "second positive"
       but a < 1 and b < 1
           see "neither positive"
       ok
       see nl
