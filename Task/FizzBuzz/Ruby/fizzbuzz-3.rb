class Enumerator::Lazy
  def filter_map
    Lazy.new(self) do |holder, *values|
      result = yield *values
      holder << result if result
    end
  end
end

class Fizz
  def initialize(head, tail)
    @list = (head..Float::INFINITY).lazy.filter_map{|i| i if i % 3 == 0}.first(tail)
  end

  def fizz?(num)
    search = @list
    search.include?(num)
  end

  def drop(num)
    list = @list
    list.delete(num)
  end

  def to_a
    @list.to_a
  end
end

class Buzz
  def initialize(head, tail)
    @list = (head..Float::INFINITY).lazy.filter_map{|i| i if i % 5 == 0}.first(tail)
  end

  def buzz?(num)
    search = @list
    search.include?(num)
  end

  def drop(num)
    list = @list
    list.delete(num)
  end

  def to_a
    @list.to_a
  end
end

class FizzBuzz
  def initialize(head, tail)
    @list = (head..Float::INFINITY).lazy.filter_map{|i| i if i % 15 == 0}.first(tail)
  end

  def fizzbuzz?(num)
    search = @list
    search.include?(num)
  end

  def to_a
    @list.to_a
  end

  def drop(num)
    list = @list
    list.delete(num)
  end
end
stopper = 100
@fizz = Fizz.new(1,100)
@buzz = Buzz.new(1,100)
@fizzbuzz = FizzBuzz.new(1,100)
def min(v, n)
  if v == 1
    puts "Fizz: #{n}"
    @fizz::drop(n)
  elsif v == 2
    puts "Buzz: #{n}"
    @buzz::drop(n)
  else
    puts "FizzBuzz: #{n}"
    @fizzbuzz::drop(n)
  end
end
(@fizz.to_a & @fizzbuzz.to_a).map{|d| @fizz::drop(d)}
(@buzz.to_a & @fizzbuzz.to_a).map{|d| @buzz::drop(d)}
while @fizz.to_a.min < stopper or @buzz.to_a.min < stopper or @fizzbuzz.to_a.min < stopper
  f, b, fb = @fizz.to_a.min, @buzz.to_a.min, @fizzbuzz.to_a.min
  min(1,f)  if f < fb and f < b
  min(2,b)  if b < f and b < fb
  min(0,fb) if fb < b and fb < f
end
