class Array
  def stable_sort
    n = -1
    if block_given?
      collect {|x| n += 1; [x, n]
      }.sort! {|a, b|
        c = yield a[0], b[0]
        if c.nonzero? then c else a[1] <=> b[1] end
      }.collect! {|x| x[0]}
    else
      sort_by {|x| n += 1; [x, n]}
    end
  end

  def stable_sort_by
    block_given? or return enum_for(:stable_sort_by)
    n = -1
    sort_by {|x| n += 1; [(yield x), n]}
  end
end
