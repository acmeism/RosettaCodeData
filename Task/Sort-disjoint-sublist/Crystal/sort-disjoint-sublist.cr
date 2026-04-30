module Indexable::Mutable
  def sort_at! (indices)
    indices = indices.sort
    indices.map {|idx| self[idx] }.sort.zip(indices) {|v, idx| self[idx] = v }
    self
  end
end

values = [7, 6, 5, 4, 3, 2, 1, 0]
indices = [6, 1, 7]

p! values, values.sort_at!(indices)
