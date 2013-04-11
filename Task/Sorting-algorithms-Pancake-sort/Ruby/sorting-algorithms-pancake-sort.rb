class Array
  def pancake_sort!
    num_flips = 0
    self.size.downto(2) do |i|
      end_idx = i - 1
      max_idx = self[0..end_idx].each_with_index.max_by {|e| e[0]}.last
      next if max_idx == end_idx

      if max_idx > 0
        self[0..max_idx] = self[0..max_idx].reverse

        if $DEBUG
          num_flips += 1
          p [num_flips, self]
        end
      end

      self[0..end_idx] = self[0..end_idx].reverse

      if $DEBUG
        num_flips += 1
        p [num_flips, self]
      end
    end

    self
  end
end

p a = (1..9).to_a.shuffle
p a.pancake_sort!
