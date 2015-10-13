/*Check whether a string is a palindrome */
parse pull string
select
	when palindrome(string) then say string 'is an exact palindrome.'
	when palindrome(compress(upper(string))) then say string 'is an inexact palindrome.'
	otherwise say string 'is not palindromic.'
	end
exit 0

palindrome: procedure
parse arg string
return string==reverse(string)
