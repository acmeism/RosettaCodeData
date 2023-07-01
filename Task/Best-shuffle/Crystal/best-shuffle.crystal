def best_shuffle(s)
  # Fill _pos_ with positions in the order
  # that we want to fill them.
  pos = [] of Int32
  # g["a"] = [2, 4] implies that s[2] == s[4] == "a"
  g = s.size.times.group_by { |i| s[i] }

  # k sorts letters from low to high count
  # k = g.sort_by { |k, v| v.length }.map { |k, v| k }        # in Ruby
  # k = g.to_a.sort_by { |(k, v)| v.size }.map { |(k, v)| k } # Crystal direct
  k = g.to_a.sort_by { |h| h[1].size }.map { |h| h[0] }       # Crystal shorter

  until g.empty?
    k.each do |letter|
      g.has_key?(letter) || next          # next unless g.has_key? letter
      pos << g[letter].pop
      g[letter].empty? && g.delete letter # g.delete(letter) if g[letter].empty?
    end
  end

  # Now fill in _new_ with _letters_ according to each position
  # in _pos_, but skip ahead in _letters_ if we can avoid
  # matching characters that way.
  letters = s.dup
  new = "?" * s.size

  until letters.empty?
    i, p = 0, pos.pop
    while letters[i] == s[p] && i < (letters.size - 1); i += 1 end
    # new[p] = letters.slice! i                            # in Ruby
    new = new.sub(p, letters[i]); letters = letters.sub(i, "")
  end
  score = new.chars.zip(s.chars).count { |c, d| c == d }
  {new, score}
end

%w(abracadabra seesaw elk grrrrrr up a).each do |word|
  # puts "%s, %s, (%d)" % [word, *best_shuffle(word)]      # in Ruby
  new, score = best_shuffle(word)
  puts "%s, %s, (%d)" % [word, new, score]
end
