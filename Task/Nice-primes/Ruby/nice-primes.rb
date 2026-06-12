require 'prime'

class Integer
  def dig_root = (1+(self-1).remainder(9))
  def nice? = prime? && dig_root.prime?
end

p (500..1000).select(&:nice?)
