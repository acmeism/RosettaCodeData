record Op, name : Char, prio : Int32, assoc : Symbol, arity : Int32, eval : Bs -> Bool

def op (name, prio, assoc, arity, eval)
  Op.new name, prio, assoc, arity, eval
end

alias Bs = Array(Bool)

OPS = {
  'T' => op('T', 1, :left,  0, ->(p : Bs) { true  }),
  'F' => op('F', 1, :left,  0, ->(p : Bs) { false }),
  '~' => op('~', 2, :right, 1, ->(p : Bs) { !p[0]         }),
  '&' => op('&', 3, :left,  2, ->(p : Bs) {  p[0] && p[1] }),
  '|' => op('|', 4, :left,  2, ->(p : Bs) {  p[0] || p[1] }),
  '^' => op('^', 4, :left,  2, ->(p : Bs) {  p[0] != p[1] }),
  '>' => op('>', 5, :left,  2, ->(p : Bs) { !p[0] || p[1] }),
  '=' => op('=', 6, :left,  2, ->(p : Bs) {  p[0] == p[1] }),
}

def to_rpn (string)
  tokens = string.delete(' ').chars
  output = [] of Char | Op
  opstack = [] of Op
  mark = op('x', -1, :none, 0, ->(p : Bs) { raise "?" })

  tokens.each do |token|
    if token == '('
      opstack << mark
    elsif token == ')'
      while opstack.present? && opstack.last != mark
        output << opstack.pop
      end
      opstack.pop
    elsif opdata = OPS[token]?
      while opstack.present? && OPS.has_key?(opstack.last.name) &&
            (opdata.prio >  opstack.last.prio ||
             opdata.prio == opstack.last.prio && opdata.assoc == :left)
        output << opstack.pop
      end
      opstack << opdata
    else
      raise "unknown symbol #{token}" unless token.letter?
      output << token.downcase
    end
  end
  while opstack.present?
    output << opstack.pop
  end
  output
end

def eval (expr)
  stack = [] of Bool
  expr.each do |op|
    if op.is_a? Op
      params = stack.pop(op.arity)
      stack.push op.eval[params]
    else
      stack.push op
    end
  end
  stack.pop
end

puts <<-EOT
Enter Boolean expressions. Operators are:
  = (eqv), > (impl), & (and), | (or), ^ (xor), ~ (not)
Constants are: T (true), F (false) (case is important!)
Variables are any letter (case isn't important, except for f and t)
EOT

loop do
  print "expression> "
  s = gets
  break if s.nil? || s == ""
  stack = to_rpn(s)
  vars = stack.select(Char).uniq.sort
  puts vars.join(" ") + " | " + s
  puts "--" * vars.size + "+-" + "-" * s.size
  Indexable.each_cartesian([[true, false]] * vars.size) do |bools|
    print bools.map(&.to_s[0].upcase).join(" ")
    vals = Hash.zip(vars, bools)
    result = eval stack.map {|elt| elt.is_a?(Char) ? vals[elt] : elt }
    puts " | #{result.to_s[0].upcase}"
  end
end
