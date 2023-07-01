numbers = ARGV.map(&:to_i)
if numbers.length == 0
  puts
  puts("usage: #{File.basename(__FILE__)} number...")
  exit
end

def maya_print(number)
  digits5s1s = number.to_s(20).chars.map { |ch| ch.to_i(20) }.map { |dig| dig.divmod(5) }
  puts(('+----' * digits5s1s.length) + '+')
  3.downto(0) do |row|
    digits5s1s.each do |d5s1s|
      if row < d5s1s[0]
        print('|----')
      elsif row == d5s1s[0]
        print("|#{[(d5s1s[0] == 0 ? ' @  ' : '    '), ' .  ', ' .. ', '... ', '....'][d5s1s[1]]}")
      else
        print('|    ')
      end
    end
    puts('|')
  end
  puts(('+----' * digits5s1s.length) + '+')
end

numbers.each do |num|
  puts(num)
  maya_print(num)
end
