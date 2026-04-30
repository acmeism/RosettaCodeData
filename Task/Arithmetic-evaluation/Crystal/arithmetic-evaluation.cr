abstract class Expression
  abstract def eval
end

class IntLiteral < Expression
  property value

  def initialize (@value : Int32)
  end

  def eval
    @value
  end

  def to_s (io)
    io << @value.to_s
  end
end

alias UnFun  = Int32 -> Int32
alias BinFun = Int32, Int32 -> Int32

class UnOp < Expression
  getter operand : Expression, op : String
  @function : UnFun

  def initialize (@operand, @op, &block : UnFun)
    @function = block
  end

  def eval
    @function.call @operand.eval
  end

  def to_s (io)
    io << @op
    @operand.to_s io
  end
end

class BinOp < Expression
  getter left : Expression, right : Expression, op : String
  @function : BinFun

  def initialize (@left, @right, @op, &block : BinFun)
    @function = block
  end

  def eval
    @function.call @left.eval, @right.eval
  end

  def to_s (io)
    io << "("
    @left.to_s io
    io << " " << @op << " "
    @right.to_s io
    io << ")"
  end
end

class Parser
  UNOPS = {
    '-' => { func: UnFun.new {|a| -a } }
  }
  BINOPS = {
    '+' => { prio: 2, func: BinFun.new {|a, b| a + b } },
    '-' => { prio: 2, func: BinFun.new {|a, b| a - b } },
    '*' => { prio: 1, func: BinFun.new {|a, b| a * b } },
    '/' => { prio: 1, func: BinFun.new {|a, b| a // b } }
  }
  @chars : Array(Char)

  def initialize (s)
    @chars = s.chars
  end

  def consume (ch)
    raise "'#{ch}' expected" unless @chars.present? && @chars.first == ch
    @chars.shift
  end

  def skip_spaces
    while @chars.present? && @chars.first.whitespace?
      @chars.shift
    end
  end

  def parse_unit
    skip_spaces
    raise "Unexpected end of input" if @chars.empty?
    case @chars.first
    when '('
      consume '('
      res = parse_binop prio: 2
      consume ')'
      res
    when .in? UNOPS.keys
      op = @chars.shift
      UnOp.new parse_unit, op.to_s, &UNOPS[op][:func]
    when '0'..'9'
      n = 0
      while @chars.present? && @chars.first.in? '0'..'9'
        n = n * 10 + @chars.shift.to_i
      end
      IntLiteral.new n
    else
      raise "Unexpected '#{@chars.first}'"
    end
  end

  def parse_binop (prio)
    left = if prio == 0
             parse_unit
           else
             parse_binop prio-1
           end
    loop do
      skip_spaces
      return left if @chars.empty?
      op = @chars.first
      opdata = BINOPS[op]?
      return left if !opdata || opdata[:prio] != prio
      consume op
      right = parse_binop prio-1
      left = BinOp.new left, right, op.to_s, &opdata[:func]
    end
  end

  def parse
    res = parse_binop prio: 2
    skip_spaces
    raise "Unexpected '#{@chars.first}'" unless @chars.empty?
    res
  end
end

formula = "1 + 2*(3 - 2*(3 - 2)*((2 - 4)*5 - 22/(7 + 2*(3 - 1)) - 1)) + -1*-1"
ast = Parser.new(formula).parse
print "Original: ", formula, "\n"
print "Parsed:   ", ast, "\n"
print "Result:   ", ast.eval, "\n"
