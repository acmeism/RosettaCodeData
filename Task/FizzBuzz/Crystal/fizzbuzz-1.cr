1.upto(100) do |v|
  p fizz_buzz(v)
end

def fizz_buzz(value)
  word = ""
  word += "fizz" if value % 3 == 0
  word += "buzz" if value % 5 == 0
  word += value.to_s if word.empty?
  word
end
