puts "You entered: #{gets}"

begin
  puts "You entered: #{gets.not_nil!.chomp.to_i}"
rescue ex
  puts ex
end
