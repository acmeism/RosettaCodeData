x = 3.25
y = 4

puts x.abs       # absolute value
puts x.floor     # floor
puts x.ceil      # ceiling
puts x ** y      # power
puts

include Math     # without including

puts E           # puts Math::E        -- exponential constant
puts PI          # puts Math::PI       -- Archimedes  circle constant
puts TAU         # puts Math::TAU      -- the correct circle constant, >= version 0.36
puts sqrt(x)     # puts Math.sqrt(x)   -- real square root
puts log(x)      # puts Math.log(x)    -- natural logarithm
puts log10(x)    # puts Math.log10(x)  -- base 10 logarithm
puts log(x, y)   # puts Math.log(x, y) -- logarithm x base y
puts exp(x)      # puts Math.exp(x)    -- exponential
puts E**x        # puts Math::E**x     -- same
