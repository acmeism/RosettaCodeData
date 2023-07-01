require "big"

struct LogRep
  private LOG2_2 = 1.0_f64
  private LOG2_3 = Math.log2 3.0_f64
  private LOG2_5 = Math.log2 5.0_f64

  def initialize(@logrep : Float64, @x2 : Int32, @x3 : Int32, @x5 : Int32)
  end

  def mult2
    LogRep.new(@logrep + LOG2_2, @x2 + 1, @x3, @x5)
  end

  def mult3
    LogRep.new(@logrep + LOG2_3, @x2, @x3 + 1, @x5)
  end

  def mult5
    LogRep.new(@logrep + LOG2_5, @x2, @x3, @x5 + 1)
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

class HammingsImpLogRep
  include Iterator(LogRep)
  private ONE = LogRep.new(0.0, 0, 0, 0)
  # use pointers to avoid bounds checking...
  @s2 = Pointer(LogRep).malloc 1024; @s3 = Pointer(LogRep).malloc 1024
  @s5 : LogRep = ONE.mult5; @mrg : LogRep = ONE.mult3
  @s2sz = 1024; @s3sz = 1024
  @s2hdi = 0; @s2tli = 0; @s3hdi = 0; @s3tli = 0

  def initialize
    @s2[0] = ONE; @s3[0] = ONE.mult3
  end

  def next
    @s2tli += 1
    if @s2hdi + @s2hdi >= @s2sz # unused is half of used
      @s2.move_from(@s2 + @s2hdi, @s2tli - @s2hdi)
      @s2tli -= @s2hdi; @s2hdi = 0
    end
    if @s2tli >= @s2sz # grow array, copying former contents
      @s2sz += @s2sz; ns2 = Pointer(LogRep).malloc @s2sz
      ns2.move_from(@s2, @s2tli); @s2 = ns2
    end
    rsltp = @s2 + @s2hdi;
    if rsltp.value < @mrg
      @s2[@s2tli] = rsltp.value.mult2; @s2hdi += 1
    else
      @s3tli += 1
      if @s3hdi + @s3hdi >= @s3sz # unused is half of used
        @s3.move_from(@s3 + @s3hdi, @s3tli - @s3hdi)
        @s3tli -= @s3hdi; @s3hdi = 0
      end
      if @s3tli >= @s3sz # grow array, copying former contents
        @s3sz += @s3sz; ns3 = Pointer(LogRep).malloc @s3sz
        ns3.move_from(@s3, @s3tli); @s3 = ns3
      end
      @s2[@s2tli] = @mrg.mult2; @s3[@s3tli] = @mrg.mult3
      @s3hdi += 1; ns3hdp = @s3 + @s3hdi
      rslt = @mrg; rsltp = pointerof(rslt)
      if ns3hdp.value < @s5
        @mrg = ns3hdp.value
      else
        @mrg = @s5; @s5 = @s5.mult5; @s3hdi -= 1
      end
    end
    rsltp.value
  end
end

print "The first 20 Hamming numbers are: "
HammingsImpLogRep.new.first(20).each { |h| print(" ", h.toBigInt) }
print ".\r\nThe 1691st Hamming number is "
HammingsImpLogRep.new.skip(1690).first(1).each { |h| print h.toBigInt }
print ".\r\nThe millionth Hamming number is "
start_time = Time.monotonic
HammingsImpLogRep.new.skip(999_999).first(1).each { |h| print h.toBigInt }
elpsd = (Time.monotonic - start_time).total_milliseconds
printf(".\r\nThis last took %f milliseconds.\r\n", elpsd)
