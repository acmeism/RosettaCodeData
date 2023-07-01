var rms = ((1..10).reduce(0) { |acc, i| acc + i*i }/10).sqrt
System.print(rms)
