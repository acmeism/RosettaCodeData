def modifier(x)  =  (x - 0.5).abs * 2

def mod_rand
  loop do
    random1, random2 = rand, rand
    return random1 if random2 < modifier(random1)
  end
end

bins = 15
bin_size = 1.0/bins
h = {}
(0...bins).each{|b| h[b*bin_size] = 0}

tally = 50_000.times.map{ (mod_rand).div(bin_size) * bin_size}.tally(h)
m = tally.values.max/40
tally.each {|k,v| puts "%f...%f  %s %d" % [k, k+bin_size, "*"*(v/m) , v] }
