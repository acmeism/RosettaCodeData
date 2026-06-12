class Ranges
  @ranges : Array(Range(Int32, Int32))

  def initialize (s = "")
    @ranges = parse_ranges(s)
    check!
  end

  def parse_ranges (s)
    s.split(",").reject!("").map {|r| Range.new(r[/^(\d+)-/, 1].to_i, r[/-(\d+)$/, 1].to_i) }
  end

  def check!
    @ranges.each_cons_pair do |a, b|
      raise "un-normalized ranges" unless a.begin <= a.end < b.begin - 1
    end
  end

  def to_s (io)
    io << @ranges.map {|r| r.begin.to_s + "-" + r.end.to_s }.join(",")
  end

  def index (n)
    @ranges.each_with_index do |r, i|
      return {:in, i}     if r.includes?(n)
      return {:before, i} if n < r.begin
    end
    {:after, @ranges.size-1}
  end

  def add (n)
    rel, idx = index(n)
    case rel
    when :in then # nothing
    when :before
      r = @ranges[idx]
      if r.begin == n + 1
        r = @ranges[idx] = Range.new(n, r.end)
      else
        r = Range.new(n, n)
        @ranges.insert(idx, r)
      end
      if idx > 0 && @ranges[idx-1].end == r.begin - 1
        @ranges[idx-1] = Range.new(@ranges[idx-1].begin, r.end)
        @ranges.delete_at idx
      end
    when :after
      if @ranges.size > 0 && @ranges[-1].end == n - 1
        @ranges[-1] = Range.new(@ranges[-1].begin, n)
      else
        @ranges << Range.new(n, n)
      end
    end
  end

  def remove (n)
    rel, idx = index(n)
    return unless rel == :in
    r = @ranges[idx]
    if n == r.begin == r.end
      @ranges.delete_at idx
    elsif n == r.begin
      @ranges[idx] = Range.new(n+1, r.end)
    elsif n == r.end
      @ranges[idx] = Range.new(r.begin, n-1)
    else
      before = Range.new(r.begin, n-1)
      after = Range.new(n+1, r.end)
      @ranges[idx] = after
      @ranges.insert idx, before
    end
  end
end

module Task
  @@r : Ranges = Ranges.new("")

  def self.start (s)
    @@r = Ranges.new s
    puts " Start: #{@@r}"
  end

  def self.add (n)
    print "   add: %2d => " % n
    @@r.add n
    puts @@r
  end

  def self.remove (n)
    print "remove: %2d => " % n
    @@r.remove n
    puts @@r
  end

  start ""
  add 77
  add 79
  add 78
  remove 77
  remove 78
  remove 79
  puts

  start "1-3,5-5"
  add 1
  remove 4
  add 7
  add 8
  add 6
  remove 7
  puts

  start "1-5,10-25,27-30"
  add 26
  add 9
  add 7
  remove 26
  remove 9
  remove 7
end
