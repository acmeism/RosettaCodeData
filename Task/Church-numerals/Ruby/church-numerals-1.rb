def zero(f)
  return lambda {|x| x}
end
Zero = lambda { |f| zero(f) }

def succ(n)
  return lambda { |f| lambda { |x| f.(n.(f).(x)) } }
end

Three = succ(succ(succ(Zero)))

def add(n, m)
  return lambda { |f| lambda { |x| m.(f).(n.(f).(x)) } }
end

def mult(n, m)
  return lambda { |f| lambda { |x| m.(n.(f)).(x) } }
end

def power(b, e)
  return e.(b)
end

def int_from_couch(f)
  countup = lambda { |i| i+1 }
  f.(countup).(0)
end

def couch_from_int(x)
  countdown = lambda { |i|
    case i
      when 0 then Zero
      else succ(countdown.(i-1))
    end
  }
  countdown.(x)
end

Four  = couch_from_int(4)

puts [ add(Three, Four),
       mult(Three, Four),
       power(Three, Four),
       power(Four, Three) ].map {|f| int_from_couch(f) }
