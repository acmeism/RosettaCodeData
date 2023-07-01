def fivenum(array)
  sorted_arr = array.sort
  n = array.size
  n4 = (((n + 3).to_f / 2.to_f) / 2.to_f).floor
  d = Array.[](1, n4, ((n.to_f + 1) / 2).to_i, n + 1 - n4, n)
  sum_array = []
  (0..4).each do |e| # each loops have local scope, for loops don't
    index_floor = (d[e] - 1).floor
    index_ceil  = (d[e] - 1).ceil
    sum_array.push(0.5 * (sorted_arr[index_floor] + sorted_arr[index_ceil]))
  end
  sum_array
end

test_array = [15, 6, 42, 41, 7, 36, 49, 40, 39, 47, 43]
tukey_array = fivenum(test_array)
p tukey_array
test_array = [36, 40, 7, 39, 41, 15]
tukey_array = fivenum(test_array)
p tukey_array
test_array = [0.14082834, 0.09748790, 1.73131507, 0.87636009, -1.95059594,
              0.73438555, -0.03035726, 1.46675970, -0.74621349, -0.72588772,
              0.63905160,  0.61501527, -0.98983780, -1.00447874, -0.62759469,
              0.66206163,  1.04312009, -0.10305385, 0.75775634,  0.32566578]
tukey_array = fivenum(test_array)
p tukey_array
