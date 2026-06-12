SIZE = ARGV.shift.to_i rescue 7

if SIZE == 1; puts "1"
elsif SIZE > 1
  (1..SIZE).each do |row|
    ch = row == 1 || row == SIZE ? "1 " : "0 "
    puts "1 #{ch * (SIZE-2)}1"
  end
end
