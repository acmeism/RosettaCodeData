OPS = {
  "^" => { prio: 4, assoc: :right },
  "*" => { prio: 3, assoc: :left  },
  "/" => { prio: 3, assoc: :left  },
  "+" => { prio: 2, assoc: :left  },
  "-" => { prio: 2, assoc: :left  },
}

class Op
  property op : String, left : Op | Float64, right : Op | Float64

  def initialize (@op, @left, @right)
  end
  def prio
    OPS[@op][:prio]
  end
  def assoc
    OPS[@op][:assoc]
  end

  def operand_infix (operand, side)
    if operand.is_a? Float64
      operand.to_s
    elsif operand.prio < self.prio ||
          operand.prio == self.prio && side != self.assoc
      "(" + operand.infix + ")"
    else
      operand.infix
    end
  end

  def infix
    operand_infix(@left, :left) + " " + @op + " " + operand_infix(@right, :right)
  end
end

def make_ast (tokens)
  stack = [] of Op | Float64
  tokens.each do |token|
    if token.is_a? Float64
      stack.push token
    else
      raise "Unknown operator '#{token}'" unless token.in? OPS.keys
      right = stack.pop
      left = stack.pop
      stack.push Op.new token, left, right
    end
    puts "%4s  [%s]" % {token, stack.map {|t| t.is_a?(Op) ? t.infix : t.to_s }.join(", ")}
  end
  raise "Unbalanced expression" unless stack.size == 1
  stack[0]
end

def tokenize (s)
  s.split.map {|t| t.to_f rescue t }
end

make_ast tokenize "10 9 8 - + 7 ^ 6 ^"  # check associativity
puts
make_ast tokenize "3 4 2 * 1 5 - 2 3 ^ ^ / +"
puts
make_ast tokenize "1 2 + 3 4 + ^ 5 6 + ^"
