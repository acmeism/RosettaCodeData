class Array
  def quick_sort
    return self if length <= 1
    pivot = sample
    group = group_by{ |x| x <=> pivot }
    group.default = []
    group[-1].quick_sort + group[0] + group[1].quick_sort
  end
end
