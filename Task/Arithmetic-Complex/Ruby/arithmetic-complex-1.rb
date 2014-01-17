require 'complex'  # With Ruby 1.9, this line is optional.

# Three ways to write complex numbers:
a = Complex(1, 1)       # 1. call Kernel#Complex
i = Complex::I          # 2. use Complex::I
b = 3.14159 + 1.25 * i
c = '1/2+3/4i'.to_c     # 3. Use the .to_c method from String, result ((1/2)+(3/4)*i)

#Ruby 2.1 introduced a suffix to create a complex:
c =  1.0/2+3/4i         # (0.5-(3/4)*i)

# Operations:
puts a + b              # addition
puts a * b              # multiplication
puts -a                 # negation
puts 1.quo a            # multiplicative inverse
puts a.conjugate        # complex conjugate
puts a.conj             # alias for complex conjugate
