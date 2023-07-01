count = 0
say "First 8 happy numbers are:"
loop i = 1 while count < 8
    if happyNumber(i) then do
        count += 1
        say i
    end
end

::routine happyNumber
  use strict arg number

  -- use to trace previous cycle results
  previous = .set~new
  loop forever
      -- stop when we hit the target
      if number = 1 then return .true
      -- stop as soon as we start cycling
      if previous[number] \== .nil then return .false
      previous~put(number)
      next = 0
      -- loop over all of the digits
      loop digit over number~makearray('')
          next += digit * digit
      end
      -- and repeat the cycle
      number = next
  end
