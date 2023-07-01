# Make types a bit easier with an alias
alias Num = Int32 | Int64 | Float32 | Float64

def accumulator(sum : Num)
  # This proc is very similar to a Ruby lambda
  ->(n : Num){ sum += n }
end

x = accumulator(5)
puts x.call(5)   #=> 10
puts x.call(10)  #=> 20
puts x.call(2.4) #=> 22.4
