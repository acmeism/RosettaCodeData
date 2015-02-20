def range_extract(l)
  # pad the list with a big value, so that the last loop iteration will
  # append something to the range
  sorted, range = l.sort.concat([Float::MAX]), []
  canidate_number = sorted.first

  # enumerate over the sorted list in pairs of current number and next by index
  sorted.each_cons(2) do |current_number, next_number|
    # if there is a gap between the current element and its next by index
    if current_number.succ < next_number
      # if current element is our first or our next by index
      if canidate_number == current_number
        # put the first element or next by index into our range as a string
        range << canidate_number.to_s
      else
        # if current element is not the same as the first or next
        # add [first or next, first or next equals current add , else -, current]
        seperator = canidate_number.succ == current_number ? "," : "-"
        range << "%d%s%d" % [canidate_number, seperator, current_number]
      end
      # make the first element the next element
      canidate_number = next_number
    end
  end
  range.join(',')
end

lst = [
    0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
   15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
   25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
   37, 38, 39
]

p rng = range_extract(lst)
