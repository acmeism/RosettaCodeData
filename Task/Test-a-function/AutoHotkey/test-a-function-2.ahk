assert(isPalindrome("in girum imus nocte et consumimur igni"), 1
, "palindrome test")
assert(broken("in girum imus nocte et consumimur igni"), "works"
, "broken test")
/*
output:
---------------------------
testPalindrome.ahk
---------------------------
broken test:
broken
expected:
works
*/

broken(x){
return "broken"
}

#Include assert.ahk
#Include palindrome.ahk
