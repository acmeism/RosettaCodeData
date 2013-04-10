module Dutch
  # Could use a class for the balls, but that's a little heavy.
  # We'll just use symbols.

  # List of colors, in order
  Symbols = [:red, :white, :blue]

  # Reverse map from symbol to numeric value
  Values  = Hash[Symbols.each_with_index.to_a]

  # Pick a color at random
  def self.random_ball
    Symbols[rand 3]
  end

  # But we will use a custom subclass of Array for the list of balls
  class Balls < Array

    # Generate a given-sized list of random balls
    def self.random(n)
      self.new(n.times.map { Dutch.random_ball })
    end

    # Test to see if the list is already in order
    def dutch?
       return true if length < 2
       Values[self[0]] < Values[self[1]] && slice(1..-1).dutch?
    end

    # Traditional in-place sort
    def dutch!
      lo = -1
      hi = length
      i = 0
      while i < hi do
        case self[i]
          when :red
            lo += 1
            self[lo], self[i] = self[i], self[lo]
            i += 1
          when :white
            i += 1
          when :blue
            hi -= 1
            self[hi], self[i] = self[i], self[hi]
        end
      end
      self
    end

    # Recursive, non-self-modifying version
    def dutch(acc = { :red => 0, :white => 0, :blue => 0})
      return self.class.new(
        Symbols.map { |c| [c] * acc[c] }.inject(&:+)
      ) if length == 0
      acc[first]+=1
      return slice(1..-1).dutch( acc )
    end
  end
end
