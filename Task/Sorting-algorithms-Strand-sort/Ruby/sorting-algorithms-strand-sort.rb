class Array
  def strandsort
    a = self.dup
    result = []
    while a.length > 0
      sublist = [a.shift]
      a.each_with_index .
        inject([]) do |remove, (val, idx)|
          if val > sublist[-1]
            sublist << val
            remove.unshift(idx)
          end
          remove
        end .
        each {|idx| a.delete_at(idx)}

      idx = 0
      while idx < result.length and not sublist.empty?
        if sublist[0] < result[idx]
          result.insert(idx, sublist.shift)
        end
        idx += 1
      end
      result += sublist if not sublist.empty?
    end
    result
  end

  def strandsort!
    self.replace(strandsort)
  end
end

p [1, 6, 3, 2, 1, 7, 5, 3].strandsort
