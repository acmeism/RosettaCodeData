module WordAddition
  def self.solve (addends, sum)
    multh = Hash(Char, Int64).new(0_i64)
    front = Set(Char).new
    all = [sum] + addends
    uniq = all.map(&.chars).flatten.uniq!

    all.each_with_index do |w, idx|
      front << w[0]
      m = idx == 0 ? -1 : 1
      w.chars.reverse.each_with_index do |ch, exp|
        multh[ch] += m * 10**exp
      end
    end

    digits = uniq.map {|ch| ch.in?(front) ? 1 : 0 }
    length = digits.size
    used = [ false ] * 10
    i = 0
    loop do
      while digits[i] < 10 && used[digits[i]]
        digits[i] += 1
      end
      if digits[i] == 10
        digits[i] = uniq[i].in?(front) ? 1 : 0
        i -= 1
        return nil if i < 0
        used[digits[i]] = false
        digits[i] += 1
        next
      end
      used[digits[i]] = true
      i += 1

      if i == length
        sum = 0_i64
        digits.each_with_index do |n, idx|
          sum += n.to_i64 * multh[uniq[idx]]
        end
        if sum == 0
          return uniq.zip(digits).to_h
        else
          i -= 1
          used[digits[i]] = false
          digits[i] += 1
        end
      end
    end
  end
end

class String
  def shorten (width = 42)
    if size > width
      self[..(width//2-2)] + "..." + self[-(width//2 - 1)..]
    else
      self
    end
  end
end

t0 = Time.monotonic

tests = [
  "SEND + MORE == MONEY",
  "I + BB == ILL",
  "A == B",
  "ACA + DD == BD",
  "A + A + A + A + A + A + A + A + A + A + A + B == BCC",
  "AS + A == MOM",
  "NO + NO + TOO == LATE",
  "HE + SEES + THE == LIGHT",
  "AND + A + STRONG + OFFENSE + AS + A + GOOD == DEFENSE",
  "SIX + SEVEN + SEVEN = TWENTY",
  "THIS+A+FIRE+THEREFORE+FOR+ALL+HISTORIES+I+TELL+A+TALE+THAT+
   FALSIFIES+ITS+TITLE+TIS+A+LIE+THE+TALE+OF+THE+LAST+FIRE+
   HORSES+LATE+AFTER+THE+FIRST+FATHERS+FORESEE+THE+HORRORS+THE+
   LAST+FREE+TROLL+TERRIFIES+THE+HORSES+OF+FIRE+THE+TROLL+RESTS+
   AT+THE+HOLE+OF+LOSSES+IT+IS+THERE+THAT+SHE+STORES+ROLES+OF+
   LEATHERS+AFTER+SHE+SATISFIES+HER+HATE+OFF+THOSE+FEARS+A+TASTE+
   RISES+AS+SHE+HEARS+THE+LEAST+FAR+HORSE+THOSE+FAST+HORSES+THAT+
   FIRST+HEAR+THE+TROLL+FLEE+OFF+TO+THE+FOREST+THE+HORSES+THAT+
   ALERTS+RAISE+THE+STARES+OF+THE+OTHERS+AS+THE+TROLL+ASSAILS+AT+
   THE+TOTAL+SHIFT+HER+TEETH+TEAR+HOOF+OFF+TORSO+AS+THE+LAST+HORSE
   +FORFEITS+ITS+LIFE+THE+FIRST+FATHERS+HEAR+OF+THE+HORRORS+THEIR+
   FEARS+THAT+THE+FIRES+FOR+THEIR+FEASTS+ARREST+AS+THE+FIRST+FATHERS
   +RESETTLE+THE+LAST+OF+THE+FIRE+HORSES+THE+LAST+TROLL+HARASSES+
   THE+FOREST+HEART+FREE+AT+LAST+OF+THE+LAST+TROLL+ALL+OFFER+THEIR+
   FIRE+HEAT+TO+THE+ASSISTERS+FAR+OFF+THE+TROLL+FASTS+ITS+LIFE+
   SHORTER+AS+STARS+RISE+THE+HORSES+REST+SAFE+AFTER+ALL+SHARE+HOT+
   FISH+AS+THEIR+AFFILIATES+TAILOR+A+ROOFS+FOR+THEIR+SAFE == FORTRESSES",
  "TO + GO = OUT",
  "SEND + A + TAD + MORE = MONEY",
  "ABRA + CADABRA + ABRA + CADABRA = HOUDINI",
  "I + GUESS + THE + TRUTH = HURTS",
  "THATS + THE + THEORY = ANYWAY",
  "SO + MANY + MORE + MEN + SEEM + TO + SAY + THAT +
   THEY + MAY + SOON + TRY + TO + STAY + AT + HOME +
   SO + AS + TO + SEE + OR + HEAR + THE + SAME + ONE +
   MAN + TRY + TO + MEET + THE + TEAM + ON + THE +
   MOON + AS + HE + HAS + AT + THE + OTHER + TEN =TESTS"
]

tests.each do |test|
  test = test.gsub(/\n\s*/, "")
  puts test.shorten
  addends, sum = test.split(/\s*=+\s*/)
  addends = addends.split(/\s*\+\s*/)
  if solution = WordAddition.solve(addends, sum)
    puts test.gsub(solution).shorten
  else
    puts "no solution"
  end
  puts
end

puts Time.monotonic - t0
