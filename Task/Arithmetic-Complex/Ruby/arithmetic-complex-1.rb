require 'complex'  # With Ruby 1.9, this line is optional.

# Two ways to write complex numbers:
a = Complex(1, 1)       # 1. call Kernel#Complex
i = Complex::I          # 2. use Complex::I
b = 3.14159 + 1.25 * i

# Operations:
puts a + b              # addition
puts a * b              # multiplication
puts -a                 # negation
puts 1.quo a            # multiplicative inverse
puts a.conjugate        # complex conjugate
puts a.conj             # alias for complex conjugate
