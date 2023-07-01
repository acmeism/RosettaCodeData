chars = (32..127).map do |ord|
  k = case ord
    when 32  then "␠"
    when 127 then "␡"
    else ord.chr
  end
  "#{ord.to_s.ljust(3)}: #{k}"
end

chars.each_slice(chars.size/6).to_a.transpose.each{|s| puts s.join("  ")}
