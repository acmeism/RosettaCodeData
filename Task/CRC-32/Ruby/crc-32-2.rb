module CRC
  # Divisor is a polynomial of degree 32 with coefficients modulo 2.
  # We store Divisor in a 33-bit Integer; the polynomial is
  #   Divisor[32] + Divisor[31] * x + ... + Divisor[0] * x**32
  Divisor = [0, 1, 2, 4, 5, 7, 8, 10, 11, 12, 16, 22, 23, 26, 32] \
    .inject(0) {|sum, exponent| sum + (1 << (32 - exponent))}

  # This table gives the crc (without conditioning) of every possible
  # _octet_ from 0 to 255. Each _octet_ is a polynomial of degree 7,
  #   octet[7] + octet[6] * x + ... + octet[0] * x**7
  # Then remainder = Table[octet] is the remainder from
  # _octet_ times x**32 divided by Divisor,
  #   remainder[31] + remainder[30] + ... + remainder[0] * x**31
  Table = Array.new(256) do |octet|
    # Find remainder from polynomial long division.
    #    octet[ 7] * x**32 + ... +   octet[0] * x**39
    #  Divisor[32] * x**0  + ... + Divisor[0] * x**32
    remainder = octet
    (0..7).each do |i|
      # Find next term of quotient. To simplify the code,
      # we assume that Divisor[0] is 1, and we only check
      # remainder[i]. We save remainder, forget quotient.
      if remainder[i].zero?
        # Next term of quotient is 0 * x**(7 - i).
        # No change to remainder.
      else
        # Next term of quotient is 1 * x**(7 - i). Multiply
        # this term by Divisor, then subtract from remainder.
        #  * Multiplication uses left shift :<< to align
        #    the x**(39 - i) terms.
        #  * Subtraction uses bitwise exclusive-or :^.
        remainder ^= (Divisor << i)
      end
    end
    remainder >> 8      # Remove x**32 to x**39 terms.
  end

  module_function

  def crc32(string, crc = 0)
    # Pre-conditioning: Flip all 32 bits. Without this step, a string
    # preprended with extra "\0" would have same crc32 value.
    crc ^= 0xffff_ffff

    # Iterate octets to perform polynomial long division.
    string.each_byte do |octet|

      # Update _crc_ by continuing its polynomial long division.
      # Our current remainder is old _crc_ times x**8, plus
      # new _octet_ times x**32, which is
      #   crc[32] * x**8 + crc[31] * x**9 + ... + crc[8] * x**31 \
      #     + (crc[7] + octet[7]) * x**32 + ... \
      #     + (crc[0] + octet[0]) * x**39
      #
      # Our new _crc_ is the remainder from this polynomial divided by
      # Divisor. We split the terms into part 1 for x**8 to x**31, and
      # part 2 for x**32 to x**39, and divide each part separately.
      # Then remainder 1 is trivial, and remainder 2 is in our Table.

      remainder_1 = crc >> 8
      remainder_2 = Table[(crc & 0xff) ^ octet]

      # Our new _crc_ is sum of both remainders. (This sum never
      # overflows to x**32, so is not too big for Divisor.)
      crc = remainder_1 ^ remainder_2
    end

    # Post-conditioning: Flip all 32 bits. If we later update _crc_,
    # this step cancels the next pre-conditioning.
    crc ^ 0xffff_ffff
  end
end

printf "0x%08x\n", CRC.crc32("The quick brown fox jumps over the lazy dog")
# => 0x414fa339
