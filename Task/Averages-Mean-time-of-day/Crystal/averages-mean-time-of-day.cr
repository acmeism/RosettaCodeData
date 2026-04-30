require "complex"

def sec_to_rad (d)
  (d - 43200) * Math::PI / 43200
end

def rad_to_sec (r)
  r * 43200 / Math::PI + 43200
end

def time_to_sec (t)
  if t =~ /^(\d\d):(\d\d):(\d\d)$/
    $1.to_i * 3600 + $2.to_i * 60 + $3.to_i
  else
    raise "invalid time format"
  end
end

def sec_to_time (s)
  h, s = s.divmod(3600)
  m, s = s.divmod(60)
  "%02d:%02d:%02d" % {h, m, s.round.to_i}
end

def rad_to_time (r)
  sec_to_time(rad_to_sec(r))
end

def time_to_rad (t)
  sec_to_rad(time_to_sec(t))
end

def mean_time (times)
  rad_to_time(times.sum {|time| time_to_rad(time).cis }.phase)
end

[["23:00:17", "23:40:20", "00:12:45", "00:17:19"]].each do |times|
  puts "The mean time of (%s) is: %s." % [times.join(" "), mean_time(times)]
 end
