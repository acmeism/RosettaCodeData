OPS = {
  "^" => { prio: 4, assoc: :right },
  "*" => { prio: 3, assoc: :left  },
  "/" => { prio: 3, assoc: :left  },
  "+" => { prio: 2, assoc: :left  },
  "-" => { prio: 2, assoc: :left  },
}

def to_rpn (tokens)
  output = [] of String | Float64
  opstack = [] of String

  tokens.each do |token|
    case token
    when .is_a?(Float64)  then output << token
    when "("              then opstack << token
    when ")"
      while opstack.present? && opstack.last != "("
        output << opstack.pop
      end
      opstack.pop
    else
      opdata = OPS[token]? || raise "Unknown operator '#{token}'"
      while opstack.present? && OPS.has_key?(opstack.last) &&
            (opdata[:prio] <  OPS[opstack.last][:prio] ||
             opdata[:prio] == OPS[opstack.last][:prio] && opdata[:assoc] == :left)
        output << opstack.pop
      end
      opstack << token
    end
  end
  while opstack.present?
    output << opstack.pop
  end
  output
end

def tokenize (s)
  s.split.map {|t| t.to_f rescue t }
end

infix = tokenize "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3"
rpn = to_rpn infix

puts infix.join(" ")
puts rpn.join(" ")
