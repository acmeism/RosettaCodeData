enum Trit
  FALSE
  MAYBE
  TRUE

  def ~ ()
    case self
    in .false? then TRUE
    in .maybe? then MAYBE
    in .true?  then FALSE
    end
  end

  def & (other : Trit)
    Math.min(self, other)
  end

  def | (other : Trit)
    Math.max(self, other)
  end

  # equivalent
  def === (other : Trit)
    case self
    in .false? then ~other
    in .maybe? then MAYBE
    in .true?  then other
    end
  end

  # if-then
  def > (other : Trit)
    case self
    in .false? then TRUE
    in .maybe? then Math.max(other, MAYBE)
    in .true?  then other
    end
  end
end

FALSE = Trit::FALSE
MAYBE = Trit::MAYBE
TRUE  = Trit::TRUE

puts "Testing some equivalences."
puts
puts "p ⊃ q ≡ ¬p ∨ q"
Indexable.each_cartesian([[FALSE, MAYBE, TRUE]] * 2) do |(p, q)|
  puts "%5s ⊃ %-5s ≡ ¬%-5s ∨ %-5s : %5s ≡ %-5s : %-5s" % {p, q, p, q, (p > q), (~p | q), (p > q) === (~p | q) }
end
puts
puts "¬(p ∨ q) ≡ ¬p ∨ ¬q"
Indexable.each_cartesian([[FALSE, MAYBE, TRUE]] * 2) do |(p, q)|
  puts "¬(%-5s ∨ %-5s) ≡ ¬%-5s ∨ ¬%-5s : %5s ≡ %-5s : %-5s" % {p, q, p, q, ~(p & q), ~p | ~q, ~(p & q) === ~p | ~q }
end
