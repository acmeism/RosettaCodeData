def validate(guess, nums)
  name, error =
    {
      invalid_character:  ->(str){ !str.scan(%r{[^\d\s()+*/-]}).empty? },
      wrong_number:       ->(str){ str.scan(/\d/).map(&:to_i).sort != nums.sort },
      multi_digit_number: ->(str){ str.match(/\d\d/) }
    }
      .find {|name, validator| validator[guess] }

  error ? puts("Invalid input of a(n) #{name.to_s.tr('_',' ')}!") : true
end

class Guess < String
  def self.get(nums)
    loop do
      print "\nEnter a guess using #{nums}: "
      input = gets.chomp
      return new(input) if validate(input, nums)
    end
  end

  def evaluate!
    as_rat = gsub(/(\d)/, 'Rational(\1,1)')
    begin
      eval "(#{as_rat}).to_f"
    rescue SyntaxError
      "[syntax error]"
    end
  end
end

def play
  nums = Array.new(4){rand(1..9)}
  loop do
    result = Guess.get(nums).evaluate!
    break if result == 24.0
    puts "Try again! That gives #{result}!"
  end
  puts "You win!"
end

play
