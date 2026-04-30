require "wait_group"

class Buckets
  @buckets : Array(Int32)
  @locks : Array(Mutex)

  def initialize (n)
    @buckets = Array.new(n, 100)
    @locks = Array.new(n) { Mutex.new }
  end

  def size
    @buckets.size
  end

  def [] (idx)
    @locks[idx].synchronize do
      @buckets[idx]
    end
  end

  def transfer (from, to, amount)
    return if from == to
    from, to, amount = to, from, amount.abs if amount < 0
    l1, l2 = from, to
    l1, l2 = l2, l1 if l1 > l2
    @locks[l1].synchronize do
      @locks[l2].synchronize do
        amount = Math.min(@buckets[from], amount)
        @buckets[from] -= amount
        @buckets[to]   += amount
      end
    end
  end

  def snapshot
    (0...@buckets.size).each do |i| @locks[i].lock end
    result = @buckets.dup
    (0...@buckets.size).reverse_each do |i| @locks[i].unlock end
    result
  end
end

# pick two buckets and make their values closer to equal
def equalize (buckets, channel)
  loop do
    b1 = rand(buckets.size)
    b2 = rand(buckets.size)
    diff = buckets[b1] - (buckets[b1] + buckets[b2]) // 2
    buckets.transfer(b1, b2, diff)
    # check termination
    select
    when stop = channel.receive
      return
    else # continue
    end
  end
end

# pick two buckets and arbitrarily redistribute their values
def distribute (buckets, channel)
  loop do
    b1 = rand(buckets.size)
    b2 = rand(buckets.size)
    buckets.transfer(b1, b2, rand(0..buckets[b1]))
    #check termination
    select
    when stop = channel.receive
      return
    else # continue
    end
  end
end

# display contents of buckets and sum
def display (buckets, channel)
  loop do
    bs = buckets.snapshot
    puts "Total: %4d, buckets: %s" % { bs.sum, bs }
    sleep 1.second
    #check termination
    select
    when stop = channel.receive
      return
    else # continue
    end
  end
end

wg = WaitGroup.new
stop_channels = Array.new(3) { Channel(Bool).new }

buckets = Buckets.new(10)

wg.spawn { display(buckets, stop_channels[0]) }
wg.spawn { equalize(buckets, stop_channels[1]) }
wg.spawn { distribute(buckets, stop_channels[2]) }

sleep 10.seconds

stop_channels.each do |ch| ch.send(true) end

wg.wait
