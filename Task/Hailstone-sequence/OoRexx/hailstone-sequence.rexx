sequence = hailstone(27)
say "Hailstone sequence for 27 has" sequence~items "elements and is ["sequence~toString('l', ", ")"]"

highestNumber = 1
highestCount = 1

loop i = 2 to 100000
    sequence = hailstone(i)
    count = sequence~items
    if count > highestCount then do
        highestNumber = i
        highestCount = count
    end
end
say "Number" highestNumber "has the longest sequence with" highestCount "elements"

-- short routine to generate a hailstone sequence
::routine hailstone
  use arg n

  sequence = .array~of(n)
  loop while n \= 1
      if n // 2 == 0 then n = n / 2
      else n = 3 * n + 1
      sequence~append(n)
  end
  return sequence
