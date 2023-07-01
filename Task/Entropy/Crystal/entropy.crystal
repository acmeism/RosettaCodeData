# Method to calculate sum of Float64 array
def sum(array : Array(Float64))
  res = 0
  array.each do |n|
    res += n
  end
  res
end

# Method to calculate which char appears how often
def histogram(source : String)
  hist = {} of Char => Int32
  l = 0
  source.each_char do |e|
    if !hist.has_key? e
      hist[e] = 0
    end
    hist[e] += 1
  end
  return Tuple.new(source.size, hist)
end

# Method to calculate entropy from histogram
def entropy(hist : Hash(Char, Int32), l : Int32)
  elist = [] of Float64
  hist.each do |el|
    v = el[1]
    c = v / l
    elist << (-c * Math.log(c, 2))
  end
  return sum elist
end

source = "1223334444"
hist_res = histogram source
l = hist_res[0]
h = hist_res[1]
puts ".[Results]."
puts "Length: " + l.to_s
puts "Entropy: " + (entropy h, l).to_s
