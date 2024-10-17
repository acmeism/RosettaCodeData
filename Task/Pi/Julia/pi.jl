let prec = precision(BigFloat), spi = "", digit = 1
    while true
      if digit > lastindex(spi)
        prec *= 2
        setprecision(prec)
        spi = string(big(π))
      end
      print(spi[digit])
      digit += 1
    end
end
