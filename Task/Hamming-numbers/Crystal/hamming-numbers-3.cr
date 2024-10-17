require "big"

# Unlike some languages like Kotlin, Crystal doesn't have a Lazy module,
# but it has closures, so it is easy to implement a LazyList class;
# Memoizes the results of the thunk so only executed once...
class LazyList(T)
  getter head
  @tail : LazyList(T)? = nil

  def initialize(@head : T, @thnk : Proc(LazyList(T)))
  end
  def initialize(@head : T, @thnk : Proc(Nil))
  end
  def initialize(@head : T, @thnk : Nil)
  end

  def tail # not thread safe without a lock/mutex...
    if thnk = @thnk
      @tail = thnk.call; @thnk = nil
    end
    @tail
  end
end

class LogRep
  private LOG2_2 = 1.0_f64
  private LOG2_3 = Math.log2 3.0_f64
  private LOG2_5 = Math.log2 5.0_f64

  def initialize(@logrep : Float64, @x2 : Int32, @x3 : Int32, @x5 : Int32)
  end

  def self.mult2(x : LogRep)
    LogRep.new(x.@logrep + LOG2_2, x.@x2 + 1, x.@x3, x.@x5)
  end

  def self.mult3(x : LogRep)
    LogRep.new(x.@logrep + LOG2_3, x.@x2, x.@x3 + 1, x.@x5)
  end

  def self.mult5(x : LogRep)
    LogRep.new(x.@logrep + LOG2_5, x.@x2, x.@x3, x.@x5 + 1)
  end

  def <(other : LogRep)
    self.@logrep < other.@logrep
  end

  def toBigInt
    expnd = -> (x : Int32, mlt : Int32) do
      rslt = BigInt.new(1); m = BigInt.new(mlt)
      while x > 0
        rslt *= m if (x & 1) > 0; m *= m; x >>= 1
      end
      rslt
    end
    expnd.call(@x2, 2) * expnd.call(@x3, 3) * expnd.call(@x5, 5)
  end
end

class HammingsLogRep
  include Iterator(LogRep)
  private BASES = [ -> (x : LogRep) { LogRep.mult5 x },
                    -> (x : LogRep) { LogRep.mult3 x },
                    -> (x : LogRep) { LogRep.mult2 x } ]
  private EMPTY = nil.as(LazyList(LogRep)?)
  private ONE = LogRep.new(0.0, 0, 0, 0)
  @ll : LazyList(LogRep)

  def initialize
    rst = uninitialized LazyList(LogRep)
    BASES.each.accumulate(EMPTY) { |u, n| HammingsLogRep.unify(u, n) }
             .skip(1).each { |ll| rst = ll.not_nil! }
    @ll = LazyList.new(ONE, ->{ rst } )
  end

  protected def self.unify(s : LazyList(LogRep)?, n : LogRep -> LogRep)
    r = uninitialized LazyList(LogRep)?
    if ss = s
      r = merge(ss, mults(n, LazyList.new(ONE, -> { r.not_nil! })))
    else
      r = mults(n, LazyList.new(ONE, -> { r.not_nil! }))
    end
    r
  end

  private def self.mults(m : LogRep -> LogRep, lls : LazyList(LogRep))
    mlts = uninitialized Proc(LazyList(LogRep), LazyList(LogRep))
    mlts = -> (ill : LazyList(LogRep)) {
      LazyList.new(m.call(ill.head), -> { mlts.call(ill.tail.not_nil!) }) }
    mlts.call(lls)
  end

  private def self.merge(x : LazyList(LogRep), y : LazyList(LogRep))
    xhd = x.head; yhd = y.head
    if xhd < yhd
      LazyList.new(xhd, -> { merge(x.tail.not_nil!, y) })
    else
      LazyList.new(yhd, -> { merge(x, y.tail.not_nil!) })
    end
  end

  def next
    rslt = @ll.head; @ll = @ll.tail.not_nil!; rslt
  end
end

print "The first 20 Hamming numbers are: "
HammingsLogRep.new.first(20).each { |h| print(" ", h.toBigInt) }
print ".\r\nThe 1691st Hamming number is "
HammingsLogRep.new.skip(1690).first(1).each { |h| print h.toBigInt }
print ".\r\nThe millionth Hamming number is "
start_time = Time.monotonic
HammingsLogRep.new.skip(999_999).first(1).each { |h| print h.toBigInt }
elpsd = (Time.monotonic - start_time).total_milliseconds
printf(".\r\nThis last took %f milliseconds.\r\n", elpsd)
