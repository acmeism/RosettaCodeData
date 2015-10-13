class Array
  def strandsort
    a = dup
    result = []
    until a.empty?
      v = a.first
      sublist, a = a.partition{|val| v=val if v<=val}   # In case of v>val, it becomes nil.

      result.each_index do |idx|
        break if sublist.empty?
        result.insert(idx, sublist.shift) if sublist.first < result[idx]
      end
      result += sublist
    end
    result
  end

  def strandsort!
    replace(strandsort)
  end
end

p [1, 6, 3, 2, 1, 7, 5, 3].strandsort
