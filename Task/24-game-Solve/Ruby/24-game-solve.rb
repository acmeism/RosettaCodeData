class TwentyFourGame
  EXPRESSIONS = [
    '((%dr %s %dr) %s %dr) %s %dr',
    '(%dr %s (%dr %s %dr)) %s %dr',
    '(%dr %s %dr) %s (%dr %s %dr)',
    '%dr %s ((%dr %s %dr) %s %dr)',
    '%dr %s (%dr %s (%dr %s %dr))',
  ]

  OPERATORS = [:+, :-, :*, :/].repeated_permutation(3).to_a

  def self.solve(digits)
    solutions = []
    perms = digits.permutation.to_a.uniq
    perms.product(OPERATORS, EXPRESSIONS) do |(a,b,c,d), (op1,op2,op3), expr|
      # evaluate using rational arithmetic
      text = expr % [a, op1, b, op2, c, op3, d]
      value = eval(text)  rescue next                 # catch division by zero
      solutions << text.delete("r")  if value == 24
    end
    solutions
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

solutions = TwentyFourGame.solve(digits)
if solutions.empty?
  puts "no solutions"
else
  puts "found #{solutions.size} solutions, including #{solutions.first}"
  puts solutions.sort
end
