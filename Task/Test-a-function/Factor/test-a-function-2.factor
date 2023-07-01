USING: palindrome tools.test ;
IN: palindrome.tests

[ t ] [ "racecar" palindrome? ] unit-test
[ f ] [ "ferrari" palindrome? ] unit-test
