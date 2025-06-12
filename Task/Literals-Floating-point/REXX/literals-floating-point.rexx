-- 19 May 2025
include Settings

say 'LITERALS FLOATING POINT'
say version
say
say 'The standard precision (numeric digits) is 9'
say
say 'Assigments are as string...'
a = 666666.666666; say a
say 'until you do a calculation'
say a/1
say
say 'Default Format...'
say 'Leading and trailing zeroes may be Left out'
l = 13
a = 123.456; say Left(a,l) '=' a/1
a = '123.456'; say Left(a,l) '=' a/1
a = "123.456"; say Left(a,l) '=' a/1
a = 0123.4560; say Left(a,l) '=' a/1
a = 12345.6E-2; say Left(a,l) '=' a/1
a = 123.456E0; say Left(a,l) '=' a/1
a = 1.23456E+2; say Left(a,l) '=' a/1
a = ' 01.23456E+02 '; say Left(a,l) '=' a/1
say
say 'Force standard, scientific or engineering Format...'
l = 11
a = 7; b = '1/'a; c = 1/a
say Left('1/'||a,l)  '=' c
say Left('Standard',l)  '=' Std(c)
say Left('Scientific',l) '=' Sci(c)
say Left('Engineering',l)  '=' Eng(c)
a = 7000000; b = '1/'a; c = 1/a
say Left('1/'||a,l)  '=' c
say Left('Standard',l)  '=' Std(c)
say Left('Scientific',l) '=' Sci(c)
say Left('Engineering',l)  '=' Eng(c)
a = 7
say Left(a,l) '=' a
say Left('Standard',l)  '=' Std(a)
say Left('Scientific',l) '=' Sci(a)
say Left('Engineering',l)  '=' Eng(a)
a = 70000000000
say Left(a,l) '=' a+0
say Left('Standard',l)  '=' Std(a)
say Left('Scientific',l) '=' Sci(a)
say Left('Engineering',l)  '=' Eng(a)
exit

include Functions
include Helper
include Abend
