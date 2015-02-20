class Amb
  class ExhaustedError < RuntimeError; end

  def initialize
    @fail = proc { fail ExhaustedError, "amb tree exhausted" }
  end

  def choose(*choices)
    prev_fail = @fail
    callcc { |sk|
      choices.each { |choice|
	callcc { |fk|
	  @fail = proc {
	    @fail = prev_fail
	    fk.call(:fail)
	  }
	  if choice.respond_to? :call
	    sk.call(choice.call)
	  else
	    sk.call(choice)
	  end
	}
      }
      @fail.call
    }
  end

  def failure
    choose
  end

  def assert(cond)
    failure unless cond
  end
end

A = Amb.new
w1 = A.choose("the", "that", "a")
w2 = A.choose("frog", "elephant", "thing")
w3 = A.choose("walked", "treaded", "grows")
w4 = A.choose("slowly", "quickly")

A.choose() unless w1[-1] == w2[0]
A.choose() unless w2[-1] == w3[0]
A.choose() unless w3[-1] == w4[0]

puts w1, w2, w3, w4
