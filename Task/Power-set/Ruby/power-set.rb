# Based on http://johncarrino.net/blog/2006/08/11/powerset-in-ruby/
# See the link if you want a shorter version. This was intended to show the reader how the method works.
class Array
  # Adds a power_set method to every array, i.e.: [1, 2].power_set
  def power_set

    # Injects into a blank array of arrays.
    # acc is what we're injecting into
    # you is each element of the array
    inject([[]]) do |acc, you|

      # Set up a new array to add into
      ret = []

      # For each array in the injected array,
      acc.each do |i|

        # Add itself into the new array
        ret << i

        # Merge the array with a new array of the current element
        ret << i + [you]
      end

      # Return the array we're looking at to inject more.
      ret

    end

  end

  # A more functional and even clearer variant.
  def func_power_set
    inject([[]]) { |ps,item|    # for each item in the Array
      ps +                      # take the powerset up to now and add
      ps.map { |e| e + [item] } # it again, with the item appended to each element
    }
  end
end

#A direct translation of the "power array" version above
class Set
    def powerset
        inject(Set[Set[]]) do |ps, item|
            ps.union ps.map {|e| e.union (Set.new [item])}
        end
    end
end
