require "string_scanner"
require "big"

class RationalCalculator
  alias BinOp = Proc(BigRational, BigRational, BigRational)
  alias UnOp  = Proc(BigRational, BigRational)

  BINOPS = [
    [ { symbol: "/", op: BinOp.new {|a, b| a / b } },
      { symbol: "*", op: BinOp.new {|a, b| a * b } } ],
    [ { symbol: "+", op: BinOp.new {|a, b| a + b } },
      { symbol: "-", op: BinOp.new {|a, b| a - b } } ]
  ]

  UNOPS = [
    { symbol: "abs", op: UnOp.new {|r| r.abs } },
    { symbol: "+",   op: UnOp.new {|r| r } },
    { symbol: "-",   op: UnOp.new {|r| -r } }
  ]

  @last_result = BigRational.new(0, 1)

  def eval (s)
    ss = StringScanner.new(s)
    result = eval_binop(ss)
    ss.skip(/\s+/)
    raise "malformed expression" unless ss.eos?
    @last_result = result
  end

  private def eval_binop (ss, prio=BINOPS.size-1)
    left = prio == 0 ? eval_unop(ss) : eval_binop(ss, prio-1)
    ss.skip(/\s+/)
    while op = BINOPS[prio].find {|o| ss.scan(o[:symbol]) }
      right = prio == 0 ? eval_unop(ss) : eval_binop(ss, prio-1)
      left = op[:op].call(left, right)
    end
    left
  end

  private def eval_unop (ss)
    ss.skip(/\s+/)
    if op = UNOPS.find {|o| ss.scan(o[:symbol]) }
      return op[:op].call(eval_unop(ss))
    end
    eval_unit ss
  end

  private def eval_unit (ss)
    ss.skip(/\s+/)
    if ss.scan('(')
      v = eval_binop ss
      ss.skip(/\s+/)
      raise "unbalanced parens" unless ss.scan(')')
      v
    elsif ss.scan(/\d+/)
      BigRational.new(ss[0].to_big_i, 1)
    elsif ss.scan('@')
      @last_result
    else
      raise "unknown symbol"
    end
  end
end

calc = RationalCalculator.new

loop do
  print "> "
  expression = gets
  break unless expression && !expression.empty?
  begin
    result = calc.eval expression
    puts "= #{result}"
    puts "= #{result.to_f}"
  rescue ex
    puts "ERROR: #{ex.message}"
  end
end
