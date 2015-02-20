def r_palindrome?(s)
  if s.length <= 1
    true
  elsif s[0] != s[-1]
    false
  else
    r_palindrome?(s[1..-2])
  end
end
