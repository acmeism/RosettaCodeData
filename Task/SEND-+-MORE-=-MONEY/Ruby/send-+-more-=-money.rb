str = "SEND + 1ORE == 1ONEY"
digits = [0,2,3,4,5,6,7,8,9] # 1 is absent
uniq_chars = str.delete("^A-Z").chars.uniq.join
res = digits.permutation(uniq_chars.size).detect do |perm|
  num_str = str.tr(uniq_chars, perm.join)
  next if num_str.match?(/\b0/) #no words can start with 0
  eval num_str
end
puts str.tr(uniq_chars, res.join)
