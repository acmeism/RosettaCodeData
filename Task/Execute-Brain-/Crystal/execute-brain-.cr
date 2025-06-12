def bfrun (code)
  code = code.chars
  data = Hash(Int32, Int32).new(0)
  dp = ip = 0
  jump_to_matching = ->(dir : Int32) {
    nest = 0
    while 0 <= ip < code.size
      case code[ip]
      when '[' then nest += dir
      when ']' then nest -= dir
      end
      break if nest == 0
      ip += dir
    end
  }
  while 0 <= ip < code.size
    case code[ip]
    when '>' then dp += 1
    when '<' then dp -= 1
    when '+' then data[dp] += 1
    when '-' then data[dp] -= 1
    when '.' then print(data[dp].chr)
    when ',' then data[dp] = STDIN.read_char.not_nil!.ord
    when '[' then jump_to_matching.call(1)  if data[dp] == 0
    when ']' then jump_to_matching.call(-1) if data[dp] != 0
    end
    ip += 1
  end
end

hello = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."

bfrun(hello)
