def best_shuffle(s)
  # Fill _pos_ with positions in the order
  # that we want to fill them.
  pos = []
  # g["a"] = [2, 4] implies that s[2] == s[4] == "a"
  g = (0...s.length).group_by { |i| s[i] }

  # k sorts letters from low to high count
  k = g.sort_by { |k, v| v.length }.map! { |k, v| k }

  until g.empty?
    k.each { |letter|
      g[letter] or next
      pos.push(g[letter].pop)
      g[letter].empty? and g.delete letter
    }
  end
  pos.reverse!

  # Now fill in _new_ with _letters_ according to each position
  # in _pos_, but skip ahead in _letters_ if we can avoid
  # matching characters that way.
  letters = s.dup
  new = "?" * s.length
  until letters.empty?
    i, p = 0, pos.shift
    i += 1 while letters[i] == s[p] and i < (letters.length - 1)
    new[p] = letters.slice! i
  end

  score = new.chars.zip(s.chars).count { |c, d| c == d }
  [new, score]
end

%w(abracadabra seesaw elk grrrrrr up a).each { |word|
  printf "%s, %s, (%d)\n", word, *best_shuffle(word)
}
