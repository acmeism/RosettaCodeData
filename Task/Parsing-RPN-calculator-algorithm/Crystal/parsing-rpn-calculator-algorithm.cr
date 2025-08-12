def rpn_calc (tokens)
  stack = [] of Float64
  tokens.each do |token|
    if token.is_a?(Float64)
      stack.push token
    else
      x = stack.pop
      y = stack.pop
      case token
      when "+" then stack.push(y + x)
      when "-" then stack.push(y - x)
      when "*" then stack.push(y * x)
      when "/" then stack.push(y / x)
      when "^" then stack.push(y ** x)
      else raise "unknown operator: #{token}"
      end
    end
    puts "%4s  %s" % {token, stack}
  end
end

def tokenize (s)
  s.split.map {|t| t.to_f rescue t }
end

rpn_calc tokenize "3 4 2 * 1 5 - 2 3 ^ ^ / +"
