def rms(seq)
  Math.sqrt(seq.inject(0.0) {|sum, x| sum + x*x} / seq.length)
end
puts rms (1..10).to_a   # => 6.2048368229954285
