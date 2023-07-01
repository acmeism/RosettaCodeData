tests = .array~of("", "[]", "][", "[][]", "][][", "[[][]]", "[]][[]")

-- add some randomly generated tests
loop i = 1 to 8
    tests~append(generateBrackets(i))
end

loop test over tests
    say test":" checkbrackets(test)
end

::routine checkBrackets
  use arg input
  -- counter of bracket groups.  Must be 0 at end to be valid
  groups = 0

  -- loop over all of the characters
  loop c over input~makearray("")
      if c == '[' then groups += 1
      else if c == ']' then groups -= 1
      else return .false  -- non-bracket char found
      -- check for a close occurring before an open
      if groups < 0 then return .false
  end
  -- should be zero at the end
  return groups == 0

-- generate a string with n pairs of brackets
::routine generateBrackets
  use arg n

  answer = .mutablebuffer~new(,2*n)

  openBracketsNeeded = n
  unclosedBrackets = 0
  loop while answer~length < 2 * n
      if random(0, 1) & openBracketsNeeded > 0 | unclosedBrackets == 0 then do
          answer~append('[')
          openBracketsNeeded -= 1
          unclosedBrackets += 1
      end
      else do
          answer~append(']')
          unclosedBrackets -= 1
      end
  end
  return answer~string
