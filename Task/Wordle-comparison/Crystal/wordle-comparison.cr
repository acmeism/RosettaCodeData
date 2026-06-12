def compare (target, guess)
  raise "different sizes" unless target.size == guess.size
  target = target.chars
  guess = guess.chars
  chars = Hash(Char, Int32).new(0).merge!(target.tally)
  # first greens:
  result = guess.map_with_index {|ch, idx|
    if target[idx] == ch
      chars[ch] -= 1
      :green
    end
  }
  # then yellows:
  result.map_with_index {|res, idx|
    if res
      res
    elsif (chars[guess[idx]] -= 1) >= 0
      :yellow
    else
      :grey
    end
  }
end

[{"ALLOW", "LOLLY"},
 {"BULLY", "LOLLY"},
 {"ROBIN", "ALERT"},
 {"ROBIN", "SONIC"},
 {"ROBIN", "ROBIN"}].each do |target, guess|
  puts "#{target} v #{guess} => #{compare(target, guess).join(", ")}"
end
