def rms(seq)
  Math.sqrt(seq.sum{|x| x*x}.fdiv(seq.size) )
end
puts rms (1..10)   # => 6.2048368229954285
