require 'rational'

class TwentyFourGamePlayer
  EXPRESSIONS = [
    '((%d %s %d) %s %d) %s %d',
    '(%d %s (%d %s %d)) %s %d',
    '(%d %s %d) %s (%d %s %d)',
    '%d %s ((%d %s %d) %s %d)',
    '%d %s (%d %s (%d %s %d))',
  ]
  OPERATORS = [:+, :-, :*, :/]

  @@objective = Rational(24,1)

  def initialize(digits)
    @digits = digits
    @solutions = []
    solve
  end

  attr_reader :digits, :solutions

  def solve
    digits.permutation.to_a.uniq.each do |a,b,c,d|
      OPERATORS.each   do |op1|
      OPERATORS.each   do |op2|
      OPERATORS.each   do |op3|
      EXPRESSIONS.each do |expr|
        # evaluate using rational arithmetic
        test = expr.gsub('%d', 'Rational(%d,1)') % [a, op1, b, op2, c, op3, d]
        value = eval(test) rescue -1  # catch division by zero
        if value == @@objective
          @solutions << expr % [a, op1, b, op2, c, op3, d]
        end
      end;end;end;end
    end
  end

end

# validate user input
digits = ARGV.map do |arg|
  begin
    Integer(arg)
  rescue ArgumentError
    raise "error: not an integer: '#{arg}'"
  end
end
digits.size == 4 or raise "error: need 4 digits, only have #{digits.size}"

player = TwentyFourGamePlayer.new(digits)
if player.solutions.empty?
  puts "no solutions"
else
  puts "found #{player.solutions.size} solutions, including #{player.solutions.first}"
  puts player.solutions.sort.join("\n")
end
