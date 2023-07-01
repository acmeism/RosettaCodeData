# 20220720 Ruby programming solution
class Writer
  attr_reader :value, :log

  def initialize(value, log = "New")
    @value = value
    if value.is_a? Proc
      @log = log
    else
      @log = log + ": " + @value.to_s
    end
  end

  def self.unit(value, log)
    Writer.new(value, log)
  end

  def bind(mwriter)
    new_value = mwriter.value.call(@value)
    new_log = @log + "\n" + mwriter.log
    self.class.new(new_value, new_log)
  end
end

lam_sqrt = ->(number) { Math.sqrt(number) }
lam_add_one = ->(number) { number + 1 }
lam_half = ->(number) { number / 2.0 }

sqrt = Writer.unit( lam_sqrt, "Took square root")
add_one = Writer.unit( lam_add_one, "Added one")
half = Writer.unit( lam_half, "Divided by 2")

m1 = Writer.unit(5, "Initial value")
m2 = m1.bind(sqrt).bind(add_one).bind(half)

puts "The final value is #{m2.value}\n\n"
puts "This value was derived as follows:"
puts m2.log
