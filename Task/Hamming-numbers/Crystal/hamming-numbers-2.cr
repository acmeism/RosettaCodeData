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

class Hammings
  include Iterator(BigInt)
  private BASES = [ 5, 3, 2 ] of Int32
  private EMPTY = nil.as(LazyList(BigInt)?)
  @ll : LazyList(BigInt)

  def initialize
    rst = uninitialized LazyList(BigInt)
    BASES.each.accumulate(EMPTY) { |u, n| Hammings.unify(u, n) }
             .skip(1).each { |ll| rst = ll.not_nil! }
    @ll = LazyList.new(BigInt.new(1), ->{ rst } )
  end

  protected def self.unify(s : LazyList(BigInt)?, n : Int32)
    r = uninitialized LazyList(BigInt)?
    if ss = s
      r = merge(ss, mults(n, LazyList.new(BigInt.new(1), -> { r.not_nil! })))
    else
      r = mults(n, LazyList.new(BigInt.new(1), -> { r.not_nil! }))
    end
    r
  end

  private def self.mults(m : Int32, lls : LazyList(BigInt))
    mlts = uninitialized Proc(LazyList(BigInt), LazyList(BigInt))
    mlts = -> (ill : LazyList(BigInt)) {
      LazyList.new(ill.head * m, -> { mlts.call(ill.tail.not_nil!) }) }
    mlts.call(lls)
  end

  private def self.merge(x : LazyList(BigInt), y : LazyList(BigInt))
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
Hammings.new.first(20).each { |h| print(" ", h) }
print ".\r\nThe 1691st Hamming number is "
Hammings.new.skip(1690).first(1).each { |h| print h }
print ".\r\nThe millionth Hamming number is "
start_time = Time.monotonic
Hammings.new.skip(999_999).first(1).each { |h| print h }
elpsd = (Time.monotonic - start_time).total_milliseconds
printf(".\r\nThis last took %f milliseconds.\r\n", elpsd)
