require "abbrev"

File.read("daynames.txt").each_line do |line|
  next if line.strip.empty?
  abbr = line.split.abbrev.invert
  puts "Minimum size: #{abbr.values.max_by(&:size).size}", abbr.inspect, "\n"
end
