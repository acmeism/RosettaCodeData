class Numeric
  def to_i?
    self == self.to_i rescue false
   end
end

# Demo
ar = [25.000000, 24.999999, 25.000100, -2.1e120, -5e-2,  # Floats
      Float::NAN, Float::INFINITY,                       # more Floats
      2r, 2.5r,                                          # Rationals
      2+0i, 2+0.0i, 5-5i]                                # Complexes

ar.each{|num| puts "#{num} integer? #{num.to_i?}" }
