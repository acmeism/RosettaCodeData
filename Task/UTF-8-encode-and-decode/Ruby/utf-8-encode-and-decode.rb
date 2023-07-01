character_arr = ["A","ö","Ж","€","𝄞"]
for c in character_arr do
    puts "Character: " + c.encode("utf-8")
    puts "Code-Point: #{c.encode("utf-8").ord.to_s(16).upcase}"
    puts "Code-Units: " + c.each_byte.map { |n| '%02X ' % (n & 0xFF) }.join
    puts ""
end
