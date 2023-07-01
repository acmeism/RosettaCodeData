include std/sequence.e -- reverse
include std/console.e -- display
include std/text.e  -- upper
include std/utils.e -- iif

IsPalindrome("abcba")
IsPalindrome("abcdef")
IsPalindrome("In girum imus nocte et consumimur igni")

procedure IsPalindrome(object s)
 display("Is '[]' a palindrome? ",{s},0)
 s = remove_all(' ',upper(s))
 display(iif(equal(s,reverse(s)),"true","false"))
end procedure
