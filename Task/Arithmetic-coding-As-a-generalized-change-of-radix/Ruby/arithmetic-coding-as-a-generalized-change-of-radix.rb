def cumulative_freq(freq)
  cf = {}
  total = 0
  freq.keys.sort.each do |b|
    cf[b] = total
    total += freq[b]
  end
  return cf
end

def arithmethic_coding(bytes, radix)

  # The frequency characters
  freq = Hash.new(0)
  bytes.each { |b| freq[b] += 1 }

  # The cumulative frequency table
  cf = cumulative_freq(freq)

  # Base
  base = bytes.size

  # Lower bound
  lower = 0

  # Product of all frequencies
  pf = 1

  # Each term is multiplied by the product of the
  # frequencies of all previously occurring symbols
  bytes.each do |b|
    lower = lower*base + cf[b]*pf
    pf *= freq[b]
  end

  # Upper bound
  upper = lower+pf

  pow = 0
  loop do
    pf /= radix
    break if pf==0
    pow += 1
  end

  enc = ((upper-1) / radix**pow)
  [enc, pow, freq]
end

def arithmethic_decoding(enc, radix, pow, freq)

  # Multiply enc by radix^pow
  enc *= radix**pow;

  # Base
  base = freq.values.reduce(:+)

  # Create the cumulative frequency table
  cf = cumulative_freq(freq)

  # Create the dictionary
  dict = {}
  cf.each_pair do |k,v|
    dict[v] = k
  end

  # Fill the gaps in the dictionary
  lchar = nil
  (0...base).each do |i|
    if dict.has_key?(i)
      lchar = dict[i]
    elsif lchar != nil
      dict[i] = lchar
    end
  end

  # Decode the input number
  decoded = []
  (0...base).reverse_each do |i|
    pow = base**i
    div = enc/pow

    c  = dict[div]
    fv = freq[c]
    cv = cf[c]

    rem = ((enc - pow*cv) / fv)

    enc = rem
    decoded << c
  end

  # Return the decoded output
  return decoded
end

radix = 10      # can be any integer greater or equal with 2

%w(DABDDB DABDDBBDDBA ABRACADABRA TOBEORNOTTOBEORTOBEORNOT).each do |str|

  enc, pow, freq = arithmethic_coding(str.bytes, radix)
  dec = arithmethic_decoding(enc, radix, pow, freq).map{|b| b.chr }.join

  printf("%-25s=> %19s * %d^%s\n", str, enc, radix, pow)

  if str != dec
    raise "\tHowever that is incorrect!"
  end
end
