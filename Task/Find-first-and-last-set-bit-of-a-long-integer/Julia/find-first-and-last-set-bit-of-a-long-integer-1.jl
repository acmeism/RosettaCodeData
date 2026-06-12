module Bits

export lwb, upb

lwb(n) = trailing_zeros(n)
upb(n) = 8 * sizeof(n) - leading_zeros(n) - 1

end  # module Bits
