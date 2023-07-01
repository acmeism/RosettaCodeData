MINUTE = 60
HOUR   = MINUTE*60
DAY    = HOUR*24
WEEK   = DAY*7

def sec_to_str(sec)
  w, rem = sec.divmod(WEEK)
  d, rem = rem.divmod(DAY)
  h, rem = rem.divmod(HOUR)
  m, s   = rem.divmod(MINUTE)
  units  = ["#{w} wk", "#{d} d", "#{h} h", "#{m} min", "#{s} sec"]
  units.reject{|str| str.start_with?("0")}.join(", ")
end

[7259, 86400, 6000000].each{|t| puts "#{t}\t: #{sec_to_str(t)}"}
