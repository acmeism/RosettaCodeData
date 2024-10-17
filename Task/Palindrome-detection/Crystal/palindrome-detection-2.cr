def palindrome_imperative(s) : Bool
  mid = s.size // 2
  last = s.size - 1
  (0...mid).each do |i|
    if s[i] != s[last - i]
      return false
    end
  end

  true
end
