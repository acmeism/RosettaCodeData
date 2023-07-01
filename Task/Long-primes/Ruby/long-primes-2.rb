require 'prime'
require 'bigdecimal'
require 'strscan'

batas = 64_000          # limit number
start = Time.now        # time of starting
lp_array = []           # array of long-prime numbers
a = BigDecimal.("1")    # number being divided, that is 1.

Prime.each(batas).each do |prime|
  cek = a.div(prime, (prime-1)*2).truncate((prime-1)*2).to_s('F')[2..-1] # Dividing 1 with prime and take its value as string.
  if (cek[0, prime-1] == cek[prime-1, prime-1])
    i = prime-2
    until i < 5
      break if cek[0, i] == cek[i, i]
      i-=1
      cek.slice!(-2, 2) # Shortening checked string to reduce checking process load
    end

    until i == 0
      break if cek[0, (cek.size/i)*i].scan(/.{#{i}}/).uniq.length == 1
      i-=1
    end

    lp_array.push(prime) if i == 0
  end
end

[500, 1000, 2000, 4000, 8000, 16000, 32000, 64000].each do |s|
  if s == 500
    puts "\nAll long primes up to  #{s} are: #{lp_array.count {|x| x < s}}. They are:"
    lp_array.each {|x| print x, " " if x < s}
  else
    print "\nAll long primes up to #{s} are: #{lp_array.count {|x| x < s}}"
  end
end

puts "\n\nTime: #{Time.now - start}"
