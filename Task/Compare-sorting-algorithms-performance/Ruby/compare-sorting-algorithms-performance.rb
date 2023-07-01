class Array
  def radix_sort(base=10)       # negative value is inapplicable.
    ary = dup
    rounds = (Math.log(ary.max)/Math.log(base)).ceil
    rounds.times do |i|
      buckets = Array.new(base){[]}
      base_i = base**i
      ary.each do |n|
        digit = (n/base_i) % base
        buckets[digit] << n
      end
      ary = buckets.flatten
    end
    ary
  end

  def quick_sort
    return self  if size <= 1
    pivot = sample
    g = group_by{|x| x<=>pivot}
    g.default = []
    g[-1].quick_sort + g[0] + g[1].quick_sort
  end

  def shell_sort
    inc = size / 2
    while inc > 0
      (inc...size).each do |i|
        value = self[i]
        while i >= inc and self[i - inc] > value
          self[i] = self[i - inc]
          i -= inc
        end
        self[i] = value
      end
      inc = (inc == 2 ? 1 : (inc * 5.0 / 11).to_i)
    end
    self
  end

  def insertion_sort
    (1...size).each do |i|
      value = self[i]
      j = i - 1
      while j >= 0 and self[j] > value
        self[j+1] = self[j]
        j -= 1
      end
      self[j+1] = value
    end
    self
  end

  def bubble_sort
    (1...size).each do |i|
      (0...size-i).each do |j|
        self[j], self[j+1] = self[j+1], self[j]  if self[j] > self[j+1]
      end
    end
    self
  end
end

data_size = [1000, 10000, 100000, 1000000]
data = []
data_size.each do |size|
  ary = *1..size
  data << [ [1]*size, ary, ary.shuffle, ary.reverse ]
end
data = data.transpose

data_type = ["set to all ones", "ascending sequence", "randomly shuffled", "descending sequence"]
print "Array size:          "
puts data_size.map{|size| "%9d" % size}.join

data.each_with_index do |arys,i|
  puts "\nData #{data_type[i]}:"
  [:sort, :radix_sort, :quick_sort, :shell_sort, :insertion_sort, :bubble_sort].each do |m|
    printf "%20s ", m
    flag = true
    arys.each do |ary|
      if flag
        t0 = Time.now
        ary.dup.send(m)
        printf "  %7.3f", (t1 = Time.now - t0)
        flag = false  if t1 > 2
      else
        print "   --.---"
      end
    end
    puts
  end
end
