fullname = favouritefruit = needspeeling = seedsremoved = false

IO.foreach("fruit.conf") do |line|
  line.chomp!
  key, value = line.split(nil, 2)
  case key
  when /^([#;]|$)/; # ignore line
  when "FULLNAME"; fullname = value
  when "FAVOURITEFRUIT"; favouritefruit = value
  when "NEEDSPEELING"; needspeeling = true
  when "SEEDSREMOVED"; seedsremoved = true
  when /^./; puts "#{key}: unknown key"
  end
end

puts "fullname = #{fullname}"
puts "favouritefruit = #{favouritefruit}"
puts "needspeeling = #{needspeeling}"
puts "seedsremoved = #{seedsremoved}"
