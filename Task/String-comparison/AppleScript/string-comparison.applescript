--Comparing two strings for exact equality
set s1 to "this"
set s2 to "that"
if s1 is s2 then
	-- strings are equal
end if

--Comparing two strings for inequality (i.e., the inverse of exact equality)
if s1 is not s2 then
	-- string are not equal
end if

-- Comparing two strings to see if one is lexically ordered before than the other
if s1 < s2 then
	-- s1 is lexically ordered before s2
end if

-- Comparing two strings to see if one is lexically ordered after than the other
if s1 > s2 then
	-- s1 is lexically ordered after s2
end if

-- How to achieve both case sensitive comparisons and case insensitive comparisons within the language
set s1 to "this"
set s2 to "This"

considering case
	if s1 is s2 then
		-- strings are equal with case considering
	end if
end considering

ignoring case -- default
	if s2 is s2 then
		-- string are equal without case considering
	end if
end ignoring

-- Demonstrate any other kinds of string comparisons that the language provides, particularly as it relates to your type system. For example, you might demonstrate the difference between generic/polymorphic comparison and coercive/allomorphic comparison if your language supports such a distinction.

-- When comparing the right object is coerced into the same type as the object left from the operator. This implicit coercion enables to compare integers with strings (containining integer values).

set s1 to "3"
set int1 to 2

if s1 < int1 then
	-- comparison is lexically
end if

if int1 < s1 then
	-- comparison is numeric
end if
