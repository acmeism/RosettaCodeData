require('bigdecimal')
require('bigdecimal/util')

# An iterator over the Lucas Sequence for 'b'.
# (The special case of: x(n) = b * x(n-1) + x(n-2).)

def lucas(b)
  Enumerator.new do |yielder|
    xn2 = 1 ; yielder.yield(xn2)
    xn1 = 1 ; yielder.yield(xn1)
    loop { xn2, xn1 = xn1, b * xn1 + xn2 ; yielder.yield(xn1) }
  end
end

# Compute the Metallic Ratio to 'precision' from the Lucas Sequence for 'b'.
# (Uses the lucas(b) iterator, above.)
# The metallic ratio is approximated by x(n) / x(n-1).
# Returns a struct of the approximate metallic ratio (.ratio) and the
# number of terms required to achieve the given precision (.terms).

def metallic_ratio(b, precision)
  xn2 = xn1 = prev = this = 0
  lucas(b).each.with_index do |xn, inx|
    case inx
      when 0
        xn2 = BigDecimal(xn)
      when 1
        xn1 = BigDecimal(xn)
        prev = xn1.div(xn2, 2 * precision).round(precision)
      else
        xn2, xn1 = xn1, BigDecimal(xn)
        this = xn1.div(xn2, 2 * precision).round(precision)
        return Struct.new(:ratio, :terms).new(prev, inx - 1) if prev == this
        prev = this
    end
  end
end

NAMES = [ 'Platinum', 'Golden', 'Silver', 'Bronze', 'Copper',
          'Nickel', 'Aluminum', 'Iron', 'Tin', 'Lead' ]

puts
puts('Lucas Sequences...')
puts('%1s  %s' % ['b', 'sequence'])
(0..9).each do |b|
  puts('%1d  %s' % [b, lucas(b).first(15)])
end

puts
puts('Metallic Ratios to 32 places...')
puts('%-9s %1s %3s  %s' % ['name', 'b', 'n', 'ratio'])
(0..9).each do |b|
  rn = metallic_ratio(b, 32)
  puts('%-9s %1d %3d  %s' % [NAMES[b], b, rn.terms, rn.ratio.to_s('F')])
end

puts
puts('Golden Ratio to 256 places...')
puts('%-9s %1s %3s  %s' % ['name', 'b', 'n', 'ratio'])
gold_rn = metallic_ratio(1, 256)
puts('%-9s %1d %3d  %s' % [NAMES[1], 1, gold_rn.terms, gold_rn.ratio.to_s('F')])
