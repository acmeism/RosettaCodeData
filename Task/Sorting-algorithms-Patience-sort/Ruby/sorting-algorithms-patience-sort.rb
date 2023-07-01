class Array
  def patience_sort
    piles = []
    each do |i|
      if (idx = piles.index{|pile| pile.last <= i})
        piles[idx] << i
      else
        piles << [i]    #create a new pile
      end
    end
    # merge piles
    result = []
    until piles.empty?
      first = piles.map(&:first)
      idx = first.index(first.min)
      result << piles[idx].shift
      piles.delete_at(idx) if piles[idx].empty?
    end
    result
  end
end

a = [4, 65, 2, -31, 0, 99, 83, 782, 1]
p a.patience_sort
