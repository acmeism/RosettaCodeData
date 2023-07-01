def generate(n : Int)
  (['[',']'] * n).shuffle.join # Implicit return
end

def is_balanced(str : String)
  count = 0
  str.each_char do |ch|
    case ch
    when '['
      count += 1
    when ']'
      count -= 1
      if count < 0
        return false
      end
    else
      return false
    end
  end
  count == 0
end

10.times do |i|
  str = generate(i)
  puts "#{str}: #{is_balanced(str)}"
end
