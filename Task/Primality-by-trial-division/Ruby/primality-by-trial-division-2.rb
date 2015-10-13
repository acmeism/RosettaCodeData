require "prime"
def prime?(value, generator = Prime::Generator23.new)
  return false if value < 2
  for num in generator
    q,r = value.divmod num
    return true if q < num
    return false if r == 0
  end
end
p (1..50).select{|i| prime?(i)}
