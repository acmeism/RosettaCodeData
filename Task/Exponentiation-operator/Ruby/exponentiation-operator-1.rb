class Numeric
  def pow(m)
    raise TypeError, "exponent must be an integer: #{m}" unless m.is_a? Integer
    puts "pow!!"

    # below requires Ruby 1.8.7
    Array.new(m, self).reduce(1, :*)

    # for earlier versions of Ruby
    #Array.new(m, self).inject(1) { |res, n| res * n }
  end
end

p 5.pow(3)
p 5.5.pow(3)
p 5.pow(3.1)
