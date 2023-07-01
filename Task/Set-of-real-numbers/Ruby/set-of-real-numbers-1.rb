class Rset
  Set = Struct.new(:lo, :hi, :inc_lo, :inc_hi) do
    def include?(x)
      (inc_lo ? lo<=x : lo<x) and (inc_hi ? x<=hi : x<hi)
    end
    def length
      hi - lo
    end
    def to_s
      "#{inc_lo ? '[' : '('}#{lo},#{hi}#{inc_hi ? ']' : ')'}"
    end
  end

  def initialize(lo=nil, hi=nil, inc_lo=false, inc_hi=false)
    if lo.nil? and hi.nil?
      @sets = []            # empty set
    else
      raise TypeError      unless lo.is_a?(Numeric) and hi.is_a?(Numeric)
      raise ArgumentError  unless valid?(lo, hi, inc_lo, inc_hi)
      @sets = [Set[lo, hi, !!inc_lo, !!inc_hi]]         # !! -> Boolean values
    end
  end

  def self.[](lo, hi, inc_hi=true)
    self.new(lo, hi, true, inc_hi)
  end

  def self.parse(str)
    raise ArgumentError  unless str =~ /(\[|\()(.+),(.+)(\]|\))/
    b0, lo, hi, b1 = $~.captures        # $~ : Regexp.last_match
    lo = Rational(lo)
    lo = lo.numerator  if lo.denominator == 1
    hi = Rational(hi)
    hi = hi.numerator  if hi.denominator == 1
    self.new(lo, hi, b0=='[', b1==']')
  end

  def initialize_copy(obj)
    super
    @sets = @sets.map(&:dup)
  end

  def include?(x)
    @sets.any?{|set| set.include?(x)}
  end

  def empty?
    @sets.empty?
  end

  def union(other)
    sets = (@sets+other.sets).map(&:dup).sort_by{|set| [set.lo, set.hi]}
    work = []
    pre = sets.shift
    sets.each do |post|
      if valid?(pre.hi, post.lo, !pre.inc_hi, !post.inc_lo)
        work << pre
        pre = post
      else
        pre.inc_lo |= post.inc_lo  if pre.lo == post.lo
        if pre.hi < post.hi
          pre.hi = post.hi
          pre.inc_hi = post.inc_hi
        elsif pre.hi == post.hi
          pre.inc_hi |= post.inc_hi
        end
      end
    end
    work << pre  if pre
    new_Rset(work)
  end
  alias | union

  def intersection(other)
    sets = @sets.map(&:dup)
    work = []
    other.sets.each do |oset|
      sets.each do |set|
        if set.hi < oset.lo or oset.hi < set.lo
          # ignore
        elsif oset.lo < set.lo and set.hi < oset.hi
          work << set
        else
          lo = [set.lo, oset.lo].max
          if set.lo == oset.lo
            inc_lo = set.inc_lo && oset.inc_lo
          else
            inc_lo = (set.lo < oset.lo) ? oset.inc_lo : set.inc_lo
          end
          hi = [set.hi, oset.hi].min
          if set.hi == oset.hi
            inc_hi = set.inc_hi && oset.inc_hi
          else
            inc_hi = (set.hi < oset.hi) ? set.inc_hi : oset.inc_hi
          end
          work << Set[lo, hi, inc_lo, inc_hi]  if valid?(lo, hi, inc_lo, inc_hi)
        end
      end
    end
    new_Rset(work)
  end
  alias & intersection

  def difference(other)
    sets = @sets.map(&:dup)
    other.sets.each do |oset|
      work = []
      sets.each do |set|
        if set.hi < oset.lo or oset.hi < set.lo
          work << set
        elsif oset.lo < set.lo and set.hi < oset.hi
          # delete
        else
          if set.lo < oset.lo
            inc_hi = (set.hi==oset.lo and !set.inc_hi) ? false : !oset.inc_lo
            work << Set[set.lo, oset.lo, set.inc_lo, inc_hi]
          elsif valid?(set.lo, oset.lo, set.inc_lo, !oset.inc_lo)
            work << Set[set.lo, set.lo, true, true]
          end
          if oset.hi < set.hi
            inc_lo = (oset.hi==set.lo and !set.inc_lo) ? false : !oset.inc_hi
            work << Set[oset.hi, set.hi, inc_lo, set.inc_hi]
          elsif valid?(oset.hi, set.hi, !oset.inc_hi, set.inc_hi)
            work << Set[set.hi, set.hi, true, true]
          end
        end
      end
      sets = work
    end
    new_Rset(sets)
  end
  alias - difference

  # symmetric difference
  def ^(other)
    (self - other) | (other - self)
  end

  def ==(other)
    self.class == other.class and @sets == other.sets
  end

  def length
    @sets.inject(0){|len, set| len + set.length}
  end

  def to_s
    "#{self.class}#{@sets.join}"
  end
  alias inspect to_s

  protected

  attr_accessor :sets

  private

  def new_Rset(sets)
    rset = self.class.new          # empty set
    rset.sets = sets
    rset
  end

  def valid?(lo, hi, inc_lo, inc_hi)
    lo < hi or (lo==hi and inc_lo and inc_hi)
  end
end

def Rset(lo, hi, inc_hi=false)
  Rset.new(lo, hi, false, inc_hi)
end
