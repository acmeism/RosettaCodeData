def auto_abbreviate (string)
  words = string.split
  return nil unless words.present?
  (1..words.max_of(&.size)).each do |n|
    return n if words.map(&.[0, n]).to_set.size == words.size
  end
  "∞"
end

File.read_lines("weekdays.txt").each_with_index do |line, i|
  puts "#{i+1}) #{auto_abbreviate(line)}  #{line}"
end
