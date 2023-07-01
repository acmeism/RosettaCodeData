val data = Seq(Complex(1,0), Complex(1,0), Complex(1,0), Complex(1,0),
               Complex(0,0), Complex(0,2), Complex(0,0), Complex(0,0))

println(fft(data))
println(rfft(fft(data)))
