print "K: "; STDOUT.flush
k = gets.not_nil!.to_f

printf "= %7.2f °C\n= %7.2f °R\n= %7.2f °F\n",
       k - 273.15, k * 1.8, k * 1.8 - 459.67
