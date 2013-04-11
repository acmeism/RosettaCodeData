def is_palindrome_r(s)
  if s.length <= 1
    true
  elsif s[0] != s[-1]
    false
  else
    is_palindrome_r(s[1..-2])
  end
end
